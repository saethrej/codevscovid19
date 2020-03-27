import { ConfigEnv, fromEnv, asSecret } from './configEnv'

class Config extends ConfigEnv {
  // =========================================================
  // API-server related configs (ports, API path, proxy, ...)
  // =========================================================
  @fromEnv('SERVER_PORT', v => parseInt(v, 10))
  SERVER_PORT = 8000

  @fromEnv('HTTPS_PORT', v => parseInt(v, 10))
  HTTPS_PORT = 9000

  @fromEnv('SERVER_ADDRESS')
  SERVER_ADDRESS: undefined | string = undefined

  @fromEnv('SERVER_PROXY_ALLOWED')
  SERVER_PROXY_ALLOWED = 'loopback, 127.0.0.1'

  @fromEnv('SERVER_ROOT_URL')
  SERVER_ROOT_URL = ''

  @fromEnv('LOG_JSON')
  LOG_JSON = true

  @asSecret
  @fromEnv('EXAMPLE_SECRETE')
  EXAMPLE_SECRETE = 'this is not logged because of @asSecret'

  // =========================================================
  // SQL DB
  // =========================================================
  // @fromEnv('SERVER_SQL_HOST')
  // sqlConnectionHost = 'localhost'

  // @fromEnv('SERVER_SQL_PORT', (v) => parseInt(v, 10))
  // sqlConnectionPort = 5432

  // @fromEnv('SERVER_SQL_DBNAME')
  // sqlConnectionDatabase = 'shannon_db'

  // @fromEnv('SERVER_SQL_USER')
  // sqlConnectionUser = 'postgres'

  // @fromEnv('SERVER_SQL_PASSWORD')
  // sqlConnectionPassword = 'todo'

  // @fromEnv('SERVER_SQL_DIALECT')
  // sqlConnectionDialect = 'postgres'

  // =========================================================
  // OWN OPTIONS
  // =========================================================

  // =========================================================
  // Helpers
  get isDevelopment() {
    return this.NODE_ENV === 'development'
  }
}

export const config = new Config()

config.load(process.env.CODELANE_CONFIG)
