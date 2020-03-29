//define database somehow

import { logger } from '../logger'
import { Request, Response } from 'express'
import {
  db_getStoresInRectangle,
  db_getPeopleInStore,
  db_getStoreData,
  db_getDailyHistory
} from '../utils/db_ops'
import { loggers } from 'winston';

function subtractDays(date:Date, days:number) {
    var result = new Date(date);
    result.setDate(result.getDate() - days);
    return result;
  }

/** brief: returns coordinates and people_in_store of all stores within given area
 * call with POST /getlocations
 *
 * @param {Request} req expects body with JSON containing elements with array of two doubles
 *          called position, up, down, right, left
 * @param {Response} res contains JSON with fields 'success', 'stores_n' and 'stores' which is
 *          a list containing all stores of the form {store_id, longitude, latitude, people_in_store}
 * @returns -
 */
exports.locations = function(req: Request, res: Response) {
    let position = req.body.position // [double, double]
    let up = req.body.up // [double, double]
    let down = req.body.down // [double, double]
    let right = req.body.right // [double, double]
    let left = req.body.left // [double, double]
    let pos = {'long': position[0], 'lat': position[1]}
    let rect = {
        'up': {'long': up[0], 'lat': up[1]},
        'down': {'long': down[0], 'lat': down[1]},
        'left': {'long': left[0], 'lat': left[1]},
        'right': {'long': right[0], 'lat': right[1]},
    }
    db_getStoresInRectangle(DB, pos, rect, function(result: any){
        let stores = result
        let counter = stores.length
        stores.forEach(function(store:any) {
            db_getPeopleInStore(DB, store.store_id, function (result: any) {
                store.people_in_store = result
                counter = counter - 1
                if (counter <= 0){
                    let reply = {
                        'status': 'success',
                        'stores_n': stores.length,
                        'stores': stores
                    }
                    res.end(JSON.stringify(reply))
                }
            })
        })
    })
}

exports.dat = function(req: Request, res: Response) {
  let id: number = parseInt(req.params.storeId)
  //end of logic
  db_getStoreData(DB, id, function(result: any) {
    res.end(JSON.stringify({ 'success': true, 'storeData': result }))
  })
}

exports.customer = function(req: Request, res: Response) {
    let store_id: number = parseInt(req.params.storeId)
    let today = new Date()
    let fin = 7
    let customers:number[] = new Array(24).fill(0);
    let i = 0
    for(i = 0; i < fin; i++){
        logger.info(i + '')
        db_getDailyHistory(DB, store_id, subtractDays(today, i + 1).toISOString().slice(0, 10), function(result: any){
            logger.info(result)
            if(result.length > 0){
                logger.info('get nr ' + i + ': ' + result[0]['customers'])
                for(let j = 0; j < customers.length; j++){
                    customers[j] += result[0]['customers'][j]
                }
            }
            else{
                fin = i
            }
            logger.info(customers)
        })
    }
    logger.info(customers)
    while (i < fin){
        i = i
        logger.info('waiting in while')
    }
    for(let j = 0; j < customers.length; j++){
        customers[j] = customers[j]/fin
    }
    res.end(JSON.stringify({'success': true, 'customers': customers}))
}

/// store_id, date, customers