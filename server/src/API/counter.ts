//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"
import {db_increase, db_decrease} from '../utils/db_ops'

exports.up = function(req: Request, res: Response) {
    let id:number = parseInt(req.params.storeId);
    let status = 'fail'
    db_increase(DB, id, function(result: any){
        res.end(JSON.stringify({'success': result}));
    });
}

exports.down = function(req: Request, res: Response) {
    let id:number = parseInt(req.params.storeId);
    let status = 'fail'
    db_decrease(DB, id, function(result: any){
        res.end(JSON.stringify({'success': result}));
    });
}