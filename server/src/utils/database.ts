// SQL Database example

// import { Sequelize } from 'sequelize-typescript'
// import { config } from '../config/config'
// import logger from '../logger'
// import glob from 'glob-promise'
// import path from 'path'
// import Job from '../models/Job';
// import sequelize = require('sequelize');

// const database = new Sequelize({
//     database: config.sqlConnectionDatabase,
//     host: config.sqlConnectionHost,
//     port: config.sqlConnectionPort,
//     dialect: config.sqlConnectionDialect,
//     username: config.sqlConnectionUser,
//     password: config.sqlConnectionPassword,
//     modelPaths: [path.join(__dirname,'../models')],
//     logging: (msg: string) => logger.debug(msg)
// })

// export async function setupDB() {
//     return database.sync({force: true});
// }

// export async function testDBConnection() {
//     try {
//         await database.authenticate()
//         logger.info('DB Connection established')
//     } catch (e) {
//         logger.error('DB Connection failes', e)
//         throw e
//     }
// }

// export async function migrate() {
//     const qi = database.getQueryInterface()
//     const modules = await glob(path.resolve(__dirname, '../models') + '/*.js')
//     for (const m of modules) {
//         try {
//             const mod = await import(m)
//             if (mod.up) {
//                 await mod.up(qi, Sequelize)
//             }
//         } catch (e) {
//             // nothing todo
//             logger.error('Migrate Error', e)
//         }
//     }

//     logger.info(modules)
// }
