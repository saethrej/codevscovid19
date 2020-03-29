//define database somehow

import { logger } from '../logger'
import { Request, Response } from 'express'
import { db_increase, db_decrease, db_getPeopleInStore } from '../utils/db_ops'

/** brief: tries to increment the store counter and returns current value
 * call with GET /counterup/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.up = function(req: Request, res: Response) {
  let id: number = parseInt(req.params.storeId)
  db_increase(DB, id, function(result_1: any) {
    db_getPeopleInStore(DB, id, function(result_2: any) {
      res.end(JSON.stringify({ success: result_1, people_in_store: result_2 }))
    })
  })
}

/** brief: tries to decrement the store counter and returns current value
 * call with GET /counterdown/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.down = function(req: Request, res: Response) {
  let id: number = parseInt(req.params.storeId)
  db_decrease(DB, id, function(result_1: any) {
    db_getPeopleInStore(DB, id, function(result_2: any) {
      res.end(JSON.stringify({ success: result_1, people_in_store: result_2 }))
    })
  })
}

/** brief: returns current value
 * call with GET /getcounter/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.value = function(req: Request, res: Response) {
  let id: number = parseInt(req.params.storeId)
  let status = 'fail'
  db_getPeopleInStore(DB, id, function(result: any) {
    res.end(JSON.stringify({ success: true, people_in_store: result }))
  })
}
