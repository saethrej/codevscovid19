//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"

exports.up = function(req: Request, res: Response) {
    logger.info(req + ' Got a GET conterup request');
    var counter = 0; //Getcounter
    counter += 1; //incrementcounter
    res.end(JSON.stringify("['status': 'True']"))
  };

exports.down = function(req: Request, res: Response) {
    logger.info(req + ' Got a GET counterdown request');
    var counter = 0;
    counter -= 1;
    res.end(JSON.stringify("['status': 'True']"))
}