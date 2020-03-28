import { stream } from "winston";

/* Project: CodeVsCovid-19
   Author:  saethrej
   Date:    28.03.2020
   Brief:   Library that takes care of DB queries and calculations via MySQL 
*/

// we require the mysql library
const mysql = require('mysql');

/** @brief initiates a database connection and returns the connection object that
            has to be passed in all subsequent functions.
*/

/** brief: initiates database connection and returns connection object
 */
export function db_connect() 
{
    var connection = mysql.createConnection({
        host: 'jenseir1.mysql.db.hostpoint.ch',
        user: 'jenseir1_saethr',
        password: 'FdAdd4G8',
        database: 'jenseir1_codevscovid19'
    });
    
    connection.connect((err: any) => {
        if (err) throw err;
    });

    console.log("successfully connected to database.");
    return connection;
}



/** brief: disconnects the server from the database
 * 
 * @param {*} dbcon the database connection
 */
function db_disconnect(dbcon: any)
{
    dbcon.end();
}

/** brief: returns the number of stores in the database
 * 
 * @param {*} dbcon the database connection
 */
export function db_getNumStores(dbcon: any, callback: any)
{
    var sql = "SELECT count(*) FROM Stores";
    dbcon.query(sql, function(err:any, result:any) {
        if (err) {
            throw err;
        }
        console.log(result);
        return callback(result);
    });

}

/** brief: returns a list of stores (store_id, long, lat) within a certain radius
 *         of the current position
 * 
 * @param {MySQL connection} dbcon the database connection
 * @param {*} pos the target location (long, lat)
 * @param {number} radius the radius to search for stores in [km]
 */
function db_getStoresWithinRadius(dbcon: any, pos: any, radius: any)
{
    
    var sql = "SELECT store_id, longitude, latitude \
               FROM Stores \
               WHERE ";
}


export function db_increase(dbcon: any, store_id: any, callback: any){
    return callback(true);
}

export function db_decrease(dbcon: any, store_id: any, callback: any){
    return callback(true);
}