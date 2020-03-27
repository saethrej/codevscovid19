import * as winston from 'winston'
import safeJsonStringify from 'safe-json-stringify'
import { config } from './config/config'

// export const logger = createLogger({
//   transports: [
//     new transports.Console({
//       format:  format.combine(
//         // winston.format.colorize(),
//         // winston.format.timestamp(),
//         // winston.format.prettyPrint()
//         format.cli()
//         // format.timestamp(),
//         // format.align(),
//         // format.printf(info => `${info.timestamp} ${info.level}: ${info.message}`)
//       )
//     })
//   ]
// })
const splatToArguments = winston.format(info => {
  // eslint-disable-next-line @typescript-eslint/strict-boolean-expressions
  if (!(info as any)[Symbol.for('splat')]) {
    return info
  }

  let [_meta, ...args] = (info as any)[Symbol.for('splat')]
  return {
    ...info,
    arguments: args
  }
})

const multiLineJsonArguments = winston.format.printf(info => {
  // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
  return `${info.timestamp}  ${info.level}  ${info.message}  ${
    // eslint-disable-next-line @typescript-eslint/strict-boolean-expressions
    (info as any)['arguments']
      ? ': ' + safeJsonStringify((info as any)['arguments'], undefined, 2)
      : ''
  }`
})

let format
if (config.LOG_JSON) {
  format = winston.format.combine(
    winston.format.timestamp(),
    splatToArguments(),
    winston.format.json()
  )
} else {
  format = winston.format.combine(
    winston.format.colorize(),
    winston.format.timestamp(),
    splatToArguments(),
    multiLineJsonArguments
  )
}

export const logger = winston.createLogger({
  level: 'info',
  format: format,
  // defaultMeta: { service: 'user-service' },
  transports: [
    //
    // - Write to all logs with level `info` and below to `combined.log`
    // - Write all logs error (and below) to `error.log`.
    //
    // new winston.transports.File({ filename: 'error.log', level: 'error' }),
    // new winston.transports.File({ filename: 'combined.log' })
  ]
})

//
// If we're not in production then log to the `console` with the format:
// `${info.level}: ${info.message} JSON.stringify({ ...rest }) `
//
// if (process.env.NODE_ENV !== 'production') {

logger.add(new winston.transports.Console())
// }
const loggerAny: any = logger
// patching we dont want to give meta as second argument
loggerAny._log = logger.log
loggerAny.log = (
  levelOrObject: string | object,
  message: string,
  ...splat: any[]
) => {
  if (typeof levelOrObject === 'string') {
    loggerAny._log({
      level: levelOrObject,
      message: message,
      arguments: splat
    })
  } else {
    loggerAny._log(levelOrObject)
  }
  return
}

export default logger
