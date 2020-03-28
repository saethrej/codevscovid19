//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"

exports.locations = function(req: Request, res: Response) {
    logger.info('Got a GET getLocations request');
    //logic
    res.end(JSON.stringify("['status': 'True']"))
  };

exports.dat = function(req: Request, res: Response) {
    let id = req.params.id;
    logger.info('Got a GET getStoreData request');
    //logic
    res.end(JSON.stringify("['status': 'True']"))
}