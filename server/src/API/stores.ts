//define database somehow

import { logger } from '../logger'
import { Request, Response } from 'express'
import {
    db_getStoresInRectangle,
    db_getStoreUtil,
    db_getStoreData,
    db_getDailyHistory
} from '../utils/db_ops'
import { loggers } from 'winston';

function subtractDays(date: Date, days: number) {
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
exports.locations = function (req: Request, res: Response) {
    let position = req.body.position // [double, double]
    let up = req.body.up // [double, double]
    let down = req.body.down // [double, double]
    let right = req.body.right // [double, double]
    let left = req.body.left // [double, double]
    let pos = { 'long': position[0], 'lat': position[1] }
    let rect = {
        'up': { 'long': up[0], 'lat': up[1] },
        'down': { 'long': down[0], 'lat': down[1] },
        'left': { 'long': left[0], 'lat': left[1] },
        'right': { 'long': right[0], 'lat': right[1] },
    }
    db_getStoresInRectangle(DB, pos, rect, function (result: any) {
        if (result.length > 0) {
            let stores = result
            let counter = stores.length
            stores.forEach(function (store: any) {
                db_getStoreUtil(DB, store.store_id, function (result: any) {
                    store.people_in_store = result[0]
                    store.max_people = result[1]
                    counter = counter - 1
                    if (counter <= 0) {
                        let reply = {
                            'success': true,
                            'stores_n': stores.length,
                            'stores': stores
                        }
                        res.end(JSON.stringify(reply))
                    }
                })
            })
        }
        else {
            res.end(JSON.stringify({ 'success': false, 'stores_n': 0 }))
        }
    })
}

exports.dat = function (req: Request, res: Response) {
    let id: number = parseInt(req.params.storeId)
    db_getStoreData(DB, id, function (result: any) {
        if (result.length > 0) {
            res.end(JSON.stringify({ 'success': true, 'storeData': result }))
        }
        else {
            res.end(JSON.stringify({ 'success': false }))
        }
    })
}

exports.customer = function (req: Request, res: Response) {
    let store_id: number = parseInt(req.body.storeId)
    let date = req.body.date
    let this_day = new Date(date)
    let fin = 14
    let customers: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    let counter = 0
    for (let i = 0; i < fin; i++) {
        db_getDailyHistory(DB, store_id, subtractDays(this_day, i + 1).toISOString().slice(0, 10), function (result: any) {
            if (result.length > 0) {
                let times = JSON.parse(result[0]['customers'])
                if (times.length > 0) {
                    if (((i + 1) % 7) == 0) {
                        for (let j = 0; j < times.length; j++) {
                            customers[j] += times[j] * 4
                        }
                        counter += 4
                    }
                    else {
                        for (let j = 0; j < times.length; j++) {
                            customers[j] += times[j]
                        }
                        counter += 1
                    }
                }
            }
            if (i + 1 == fin) {
                for (let j = 0; j < customers.length; j++) {
                    customers[j] = customers[j] / counter
                }
                res.end(JSON.stringify({ 'success': true, 'day': date, 'storeId': store_id, 'customers': customers }))
            }
        })
    }
}