//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"

exports.check = function(req: Request, res: Response) {
    logger.info(req + ' Got a POST QRCheck request');
    //insert logic
    res.end(JSON.stringify("['status': 'True']"))
  };