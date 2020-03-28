//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"

exports.up = function(req: Request, res: Response) {
    logger.info(req + ' Got a POST conterup request');
    let storeid = req.body.storeid
    let err = true//db logic countup(dbconnection, storeid)
    if (err)
        res.end(JSON.stringify("['status': 'False']"));
    else
        res.end(JSON.stringify("['status': 'True']"));
  };

exports.down = function(req: Request, res: Response) {
    logger.info(req + ' Got a POST counterdown request');
    let storeid = req.body.storeid
    let err = true//db logic countdown(dbconnection, storeid)
    if (err)
        res.end(JSON.stringify("['status': 'False']"));
    else
        res.end(JSON.stringify("['status': 'True']"));
}