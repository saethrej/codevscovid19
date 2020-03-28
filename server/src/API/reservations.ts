//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"

exports.pre = function(req: Request, res: Response) {
    logger.info('Got a POST preReservation request');
    //logic
    res.end(JSON.stringify("['status': 'True']"))
  };

exports.confirm = function(req: Request, res: Response) {
    logger.info('Got a POST getReservation request');
    //logic
    res.end(JSON.stringify("['status': 'True']"))
}