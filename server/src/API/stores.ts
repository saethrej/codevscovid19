//define database somehow

import { logger } from '../logger'
import {Request, Response} from "express"
import { db_getNumStores } from '../utils/db_ops';
import { test_db_getNumStores } from '../utils/db_ops';

exports.locations = function(req: Request, res: Response) {
    let position = req.body.position;
    let height = req.body.mapHeight;
    let width = req.body.mapWidth;
    let zoom = req.body.zoom;
    // start of logic
    let stores = [{
        'store_id': 42,
        'longitutude': 47.395481,
        'latitude': 8.540280,
        'capacity_left': 10
    }]; // sqlquery db.getlocations(position, height, width, zoom)
    let storenr = '';
    db_getNumStores(DB, function(result: any){
        storenr = result[0]['count(*)'];
        console.log(storenr);
        let reply = {
            'status': 'success',
            'stores_n': storenr,
            'stores': [ 
                stores
            ]
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