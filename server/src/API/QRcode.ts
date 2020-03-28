//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"
import {db_checkReservation} from '../utils/db_ops'

exports.check = function(req: Request, res: Response) {
    let store_id:number = parseInt(req.params.store_id); //number
    let reservation_id:number = parseInt(req.params.reservation_id); //QR Code
    db_checkReservation(DB, store_id, reservation_id, function(result: any){
        res.end(JSON.stringify({'success': result}));
    });
}