//define database somehow

import { logger } from '../logger'
import { Request, Response } from 'express'
import { db_increase, db_decrease, db_getPeopleInStore, db_checkCredentials } from '../utils/db_ops'

/** brief: tries to increment the store counter and returns current value
 * call with GET /counterup/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.up = function (req: Request, res: Response) {
    let store_id: number = parseInt(req.params.storeId)
    //dummy values for testing if none provided
    let pw = 'a7YLnpYh1b'
    let username = '2coolMovie'
    if (typeof req.get('user') !== 'undefined') {
        username = req.get('user') + ''
    }
    if (typeof req.get('pw') !== 'undefined') {
        pw = req.get('pw') + ''
    }
    db_checkCredentials(DB, store_id, username, pw, function (authenticated: boolean) {
        if (true) { //replace true with authenticated. currently authentication ignored for testing
            db_increase(DB, store_id, function (result_1: any) {
                db_getPeopleInStore(DB, store_id, function (result_2: any) {
                    res.end(JSON.stringify({ success: result_1, people_in_store: result_2 }))
                })
            })
        }
        else {
            res.end(JSON.stringify({ 'success': false, 'error': 'not_authorized' }))
        }
    })
}

/** brief: tries to decrement the store counter and returns current value
 * call with GET /counterdown/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.down = function (req: Request, res: Response) {
    let store_id: number = parseInt(req.params.storeId)
    //dummy values for testing if none provided
    let pw = 'a7YLnpYh1b'
    let username = '2coolMovie'
    if (typeof req.get('user') !== 'undefined') {
        username = req.get('user') + ''
    }
    if (typeof req.get('pw') !== 'undefined') {
        pw = req.get('pw') + ''
    }
    db_checkCredentials(DB, store_id, username, pw, function (authenticated: boolean) {
        if (true) { //replace true with authenticated. currently authentication ignored for testing
            db_decrease(DB, store_id, function (result_1: any) {
                db_getPeopleInStore(DB, store_id, function (result_2: any) {
                    res.end(JSON.stringify({ success: result_1, people_in_store: result_2 }))
                })
            })
        }
        else {
            res.end(JSON.stringify({ 'success': false, 'error': 'not_authorized' }))
        }
    })
}
/** brief: returns current counter value of specified store
 * call with GET /getcounter/{id}
 *
 * @param {Request} req expects storeId:number with store id
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */
exports.value = function (req: Request, res: Response) {
    let id: number = parseInt(req.params.storeId)
    let status = 'fail'
    db_getPeopleInStore(DB, id, function (result: any) {
        res.end(JSON.stringify({ success: true, people_in_store: result }))
    })
}
