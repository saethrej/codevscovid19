import 'reflect-metadata'
import * as ewinston from 'express-winston'

import logger from './logger'
import { config } from './config/config'
import { errorMiddleware } from './utils/http'

import { useExpressServer } from 'routing-controllers'
import { useSocketServer } from 'socket-controllers'
import io from 'socket.io'

import express = require('express')
import https from 'https'
import fs from 'fs'
import http from 'http'

import bodyParser = require('body-parser')

import { db_connect } from './utils/db_ops'

const db = db_connect();
global.DB = db;

// global listener to log uncaught exceptions
process.on('uncaughtException', function(err) {
  logger.error('Unhandled Exception:', err, err.stack)
})

logger.info('Config loaded: ', config)
// set up basic express parameters such as allowed proxies, cors, body parser etc
const app = express()
app.set('trust proxy', config.SERVER_PROXY_ALLOWED)
app.set('http_port', config.SERVER_PORT ?? 8000)
app.set('https_port', config.HTTPS_PORT ?? 8001)
app.use(ewinston.logger({ winstonInstance: logger, expressFormat: true }))
//
useExpressServer(app, {
  routePrefix: config.SERVER_ROOT_URL,
  controllers: [`${__dirname}/controllers/**/*.cont.js`],
  defaultErrorHandler: false,
  cors: true
})

// last listener for error handling
// error handler
app.use(errorMiddleware)

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var routes = require('./API/routes'); //importing route
routes(app); //register the route

// log all remaining unhandled errors
// app.use(ewinston.errorLogger({ winstonInstance: logger }))
async function startup() {
  // await setupDB()

  const httpServer = http.createServer(app)
  // const options = {
  //  key: fs.readFileSync('./cert/key.pem'),
  //  cert: fs.readFileSync('./cert/cert.pem')
  // }
  const httpsServer = https.createServer(app)
  //controllers for message controlling
  //middleware for authentication
  const ioserver = io()
  ioserver.attach(httpServer)
  ioserver.attach(httpsServer)
  useSocketServer(ioserver, {
    controllers: [`${__dirname}/controllers/**/*.sockcont.js`],
    middlewares: [`${__dirname}/controllers/**/*.iomiddleware.js`]
  })

  httpServer.on('error', err => {
    logger.error('Cannot set up express server!', err)
  })

  httpServer.listen(config.SERVER_PORT, () => {
    logger.info(
      `Listening on ${config.SERVER_ADDRESS ?? '0.0.0.0'}:${config.SERVER_PORT}`
    )
  })

  httpsServer.on('error', err => {
    logger.error('Cannot set up express server!', err)
  })

  httpsServer.listen(config.HTTPS_PORT, () =>
    logger.info(
      `Listening on ${config.SERVER_ADDRESS ?? '0.0.0.0'}:${config.HTTPS_PORT}`
    )
  )
}

startup().catch(err => {
  logger.error('FATAL Error', err)
  logger.error('Server exit')
  return null
})
