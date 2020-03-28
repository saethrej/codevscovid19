//define database somehow

import { logger } from '../logger'
import { Request, Response } from "express"
import { db_makeReservation } from '../utils/db_ops'


exports.pre = function (req: Request, res: Response) {
    logger.info('Got a POST preReservation request');
    //logic
    res.end(JSON.stringify("['status': 'True']"))
}


exports.confirm = function (req: Request, res: Response) {

    let store_id = 1; //
    let date = "2020-03-30"; //
    let time = "12:00" //
    let email = "not@needed.anymore" //

    db_makeReservation(DB, store_id, date, time, email, function (result: any) {
        if (result != {}){
            res.end(JSON.stringify({ 'success': true, 'reservationDetails': result }));
        }
        else {
            res.end(JSON.stringify({'success': false}));
        }
    });
}