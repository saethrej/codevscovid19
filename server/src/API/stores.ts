//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"
import { db_getNumStores } from '../utils/db_ops'

exports.locations = function(req: Request, res: Response) {
    let position = req.body.position; // [double, double]
    let up = req.body.up; // [double, double]
    let down = req.body.down; // [double, double]
    let right = req.body.right; // [double, double]
    let left = req.body.left; // [double, double]
    // sqlquery db.getlocations(position, height, width, zoom)
    let storenr = '';
    let stores = [{
        'longitutude': 47.395481, //double
        'latitude': 8.540280, //double
        'numPeople': 10, //int
        'id': 42 //int
    }]; 
    db_getNumStores(DB, function(result: any){
        storenr = result[0]['count(*)'];
        console.log(storenr);
        let reply = {
            'status': 'success',
            'stores_n': storenr,
            'stores': stores
        };
        res.end(JSON.stringify(reply))
    });
  };

exports.dat = function(req: Request, res: Response) {
    let id = req.params.id;
    //logic
    let query_result = {}; //sqlquery db.getinfo(store_id)
    let reply = {
        'status': 'success',
        'store_info': query_result
    };
    //end of logic
    res.end(JSON.stringify(reply))
}