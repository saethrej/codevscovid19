//define database somehow

import { logger } from '../logger'
import { Request, Response } from "express"
import { db_getStoreReservations, db_getStoreData, db_confirmReservation, db_reserveReservationSlot } from '../utils/db_ops'


exports.pre = function (req: Request, res: Response) {
    logger.info('Got a POST preReservation request')
    //logic
    res.end(JSON.stringify("['status': 'True']"))
}

/** brief: returns available reservations
 * call with GET /getavailableReservations/{id}
 * 
 * @param {Request} req expects storeId:number with store id and date:yyyy-mm-dd with date of interest
 * @param {Response} res contains JSON with field 'success' and 'people_in_store'
 * @returns -
 */

exports.available = function (req: Request, res: Response) {
    let store_id = req.body.storeId
    let date: string = req.body.date
    var requestdate = new Date(date)
    logger.info(requestdate)
    var currentdate = new Date()
    var datetime = currentdate.toISOString();
    let date_today = datetime.slice(0, 10) // get todays date
    let time_current = parseInt(datetime.slice(11, 13) + datetime.slice(14, 16)) + 200 //account for timezone difference
    let cur_100 = time_current % 100
    if (cur_100 > 45) {
        time_current = time_current - cur_100 + 100
    }
    else if (cur_100 > 30) {
        time_current = time_current - cur_100 + 45
    }
    else if (cur_100 > 15) {
        time_current = time_current - cur_100 + 30
    }
    else if (cur_100 > 0) {
        time_current = time_current - cur_100 + 15
    }
    var weekdays = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
    let weekday = weekdays[requestdate.getDay()] //get current weekday

    db_getStoreData(DB, store_id, function (result: any) {
        if (result == 0) {
            res.end(JSON.stringify({
                'success': false,
                'storeId': 'unkown',
                'date': date
            }))
        }
        else {
            let maxRes = result[0]['max_reservations']
            let hour_open = parseInt(result[0][weekday + '_open'].substring(0, 2) + result[0][weekday + '_open'].substring(3, 5))
            let hour_close = parseInt(result[0][weekday + '_close'].substring(0, 2) + result[0][weekday + '_close'].substring(3, 5))
            if (date == date_today && time_current > hour_open) {
                hour_open = time_current
            }
            db_getStoreReservations(DB, store_id, date, function (result_2: any) {
                let reservations = result_2
                let open_slots: any = []
                let time = hour_open
                let slots = maxRes
                let res_time = time
                reservations.forEach(function (reservation: any) {
                    if (reservation['reservation_time'] == res_time) {
                        slots = slots - 1
                    }
                    else {
                        res_time = reservation['reservation_time']
                        while (time < res_time) {
                            if (slots > 0) {
                                open_slots.push({ 'time': time, 'slots': slots })
                            }
                            slots = maxRes
                            time = time + 15
                            if ((time % 100) >= 60) {
                                time += 40
                            }
                        }
                        slots = slots - 1
                    }

                })

                while (time < hour_close) {
                    if (slots > 0) {
                        open_slots.push({ 'time': time, 'slots': slots })
                    }
                    slots = maxRes
                    time = time + 15
                    if ((time % 100) >= 60) {
                        time += 40
                    }
                }
                if (open_slots.length > 0) {
                    res.end(JSON.stringify({
                        'success': true,
                        'storeId': store_id,
                        'date': date,
                        'reservations': open_slots
                    }))
                }
                else {
                    res.end(JSON.stringify({
                        'success': false,
                        'storeId': store_id,
                        'date': date
                    }))
                }
            })
        }
    })
}

exports.reserve = function (req: Request, res: Response) {
    let store_id:number = parseInt(req.body.storeId)
    let date = req.body.date
    let time = req.body.time
    db_reserveReservationSlot(DB, store_id, date, time, function (result: any) {
        if (result.length != 0){
            res.end(JSON.stringify({'success': true, 'reservationDetails': result }))
        }
        else {
            res.end(JSON.stringify({'success': false}))
        }
    })
}


exports.confirm = function (req: Request, res: Response) {

    let code_hash = req.body.code_hash
    let reservation_id = req.body.reservationId

    db_confirmReservation(DB, reservation_id, code_hash, function (result: any) {
        if (result.length != 0) {
            res.end(JSON.stringify({ 'success': true, 'reservationDetails': result }))
        }
        else {
            res.end(JSON.stringify({ 'success': false }))
        }
    })
}