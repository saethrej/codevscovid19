import * as _ from 'lodash'
import * as path from 'path'
import * as glob from 'glob'
import * as yaml from 'yaml'
import * as fs from 'fs'

// used internally to record the meta informations
interface InitEnvMeta {
  propertyKey: string
  envVariable: string
  transform: (value: string, env: any) => any
}

// the map to store configs
export interface ConfigKeyValueSet {
  [secretName: string]: any
}

// the decoration functions to load a property from the enviroment
export function fromEnv(
  envVariable: string,
  transform: (value: string, env: any) => any = v => v
) {
  return function(target: any, propertyKey: string) {
    let _t: any = null
    let metaData: InitEnvMeta = {
      propertyKey: propertyKey,
      envVariable: envVariable,
      transform: transform
    }
    if (target._initEnvs !== undefined) {
      target._initEnvs.push(metaData)
    } else {
      target._initEnvs = [metaData]
    }
  }
}

export function asSecret(target: any, propertyKey: string) {
  if (target._secretKeys !== undefined) {
    target._secretKeys.push(propertyKey)
  } else {
    target._secretKeys = [propertyKey]
  }
}

export class ConfigEnv implements ConfigKeyValueSet {
  // [secretName: string]: any;

  initEnvs: InitEnvMeta[] = []
  secretKeys: string[] = []

  @asSecret
  secrets: ConfigKeyValueSet = {}

  // file to load secrets from
  @fromEnv('SECRETS_FILE')
  secretsConfigFile = './shared_secrets.json'

  NODE_ENV = process.env.NODE_ENV ?? 'development'
  CODELANE_ENV =
    process.env.CODELANE_ENV ?? process.env.NODE_ENV ?? 'development'

  constructor() {
    this.initEnvs = (this as any)['_initEnvs']
    this.secretKeys = (this as any)['_secretKeys']
  }

  loadFromEnv() {
    const loaded: string[] = []
    if (this.initEnvs !== undefined) {
      for (let elem of this.initEnvs) {
        if (elem.envVariable in process.env) {
          loaded.push(elem.envVariable)
          this[elem.propertyKey as keyof ConfigEnv] = elem.transform(
            String(process.env[elem.envVariable]),
            process.env
          )
        }
      }
      console.log(`CONFIG: Load environment variables: [${loaded.join(',')}]`)
    }
  }

  loadFromFile(file: string) {
    if (!fs.existsSync(file)) {
      return false
    }

    try {
      const ext = path.extname(file)
      let obj: any = {}
      if (ext === '.js' || ext === '.json') {
        obj = require(file)
      } else if (ext === '.yaml' || ext === '.yml') {
        const content = fs.readFileSync(file, { encoding: 'utf8' })
        obj = yaml.parse(content)
      }
      obj = _.omit(obj, 'secrets')
      _.assign(this, obj)
      console.log(`CONFIG: Load ${file} done`)
      return true
    } catch (ex) {
      console.log(`CONFIG: Load ${file} skipped or failed`)
    } finally {
      // nothing
    }

    return false
  }

  loadSecretsFromFile(file: string, dir: string) {
    if (file === '') {
      return false
    }
    file = path.resolve(dir, file)
    if (!fs.existsSync(file)) {
      return false
    }

    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      let obj: any = require(file)
      _.assign(this.secrets, obj)
      console.log(`CONFIG: Load Secret ${file} done`)
      return true
    } catch (ex) {
      console.log(`CONFIG: Load Secret ${file} FAILED`, ex)
    } finally {
      // nothing
    }

    return false
  }

  private _load(dir: string = '.') {
    let mode = this.CODELANE_ENV

    // loading normal configs
    const files = glob.sync(`./${mode}*.@(json|yml|yaml|js)`, { cwd: dir })
    for (const file of files) {
      this.loadFromFile(path.resolve(dir, file))
    }

    this.loadFromFile(path.resolve(dir, './configLocal.yml'))

    // loading secrets
    this.loadSecretsFromFile(this.secretsConfigFile, dir)
    this.secretsConfigFile = ''
  }

  load(dir?: string) {
    this._load(process.cwd())
    if (dir !== undefined) {
      this._load(dir)
    }

    // Env variables replace other things
    this.loadFromEnv()

    // loading secrets
    if (dir !== undefined) {
      this.loadSecretsFromFile(this.secretsConfigFile, dir)
      this.secretsConfigFile = ''
    } else {
      this.loadSecretsFromFile(this.secretsConfigFile, '.')
      this.secretsConfigFile = ''
    }
  }

  toJSON() {
    return _.omit(this, [
      'initEnvs',
      '_initEnvs',
      'secretKeys',
      '_secretKeys',
      ...this.secretKeys
    ])
  }

  toString() {
    return 'Config: ' + JSON.stringify(this, null, 2)
  }
}
