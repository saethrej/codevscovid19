//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"
import {db_checkReservation, db_increase, db_getPeopleInStore} from '../utils/db_ops'

/** brief: checks if hash of QR-code allows for entry. If yes, increments store counter
 * call with POST /checkQRCode
 * 
 * @param {Request} req expects storeId:number with store id and code_hash with hash of QR_code
 * @param {Response} res contains JSON with field 'success' indicating if reservation valid
 *          and if true 'people_in_store' with incremented new number of people in store.
 * @returns -
 */
exports.check = function(req: Request, res: Response) {
    let store_id:number = parseInt(req.body.store_id) //number
    let code_hash = req.body.code_hash //QR Code
    db_checkReservation(DB, store_id, code_hash, function(result: any){
        if(result){
            db_increase(DB, store_id, function (result_1: any) {
                db_getPeopleInStore(DB, store_id, function (result_2: any) {
                    res.end(JSON.stringify({ 'success': result_1, 'people_in_store': result_2 }))
                })
            })
        }
        else{
            res.end(JSON.stringify({'success': false}))
        }
    })
}