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
 * @param {*} callback function from the caller to return result
 */
export function db_getNumStores(dbcon: any, callback: any)
{
    var sql = "SELECT count(*) FROM Stores";
    dbcon.query(sql, function(err: any, result: any, fields: any) {
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
 * @param {callback fn} callback function from the caller to return result
 * @param {*} pos the target location (long, lat)
 * @param {number} radius the radius to search for stores in [km]
 * @returns (store_id, long, lat) triplets of stores that meet criteria
 */
export function db_getStoresWithinRadius(dbcon: any, pos: any, radius: number, callback: any)
{
    // todo: compute the deviation in longitude and latitude at the current position that corresponds
    //       to 
    var sql = "SELECT store_id, longitude, latitude \
               FROM Stores \
               WHERE ";
}

/** brief: returns a list of stores (store_id, long, lat) that are currently visible on the map
 * 
 * @param dbcon the database connection
 * @param callback function from the caller to return result
 * @param pos the target position of the user
 * @param rect a list of 4 coordinates (long, lat) that bounds the visible area of the map
 */
export function db_getStoresInRectangle(dbcon: any, pos: any, rect: any, callback: any)
{
    var sql = "SELECT store_id, longitude, latitude FROM Stores \
               WHERE longitude > ? AND longitude < ? AND latitude > ? AND latitude < ?";
    dbcon.query(sql, [rect.left.long, rect.right.long, rect.low.lat, rect.up.lat], function(err: any, result: any, fields: any) {
        if (err) throw err;
        callback(result);
    });
}

/** brief: attempts to increment the store counter
 * 
 * @param {*} dbcon the database connection
 * @param {callback fn} callback function from the caller to return result
 * @param {*} store_id the unique id of the store
 * @returns true if successful, false otherwise
 */
export function db_increase(dbcon: any, store_id: number, callback: any)
{
    var sql = "UPDATE Stores SET people_in_store = people_in_store + 1 \
                 WHERE store_id = ?";
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        if (err) throw err;
        // check whether the update was successful or not
        if (result.affectedRows == 1 && result.warningCount == 0) {
            callback(true);
        } else {
            callback(false);
        }
    });
}

/** brief: attempts to decrement the store counter
 * 
 * @param {*} dbcon the database connection 
 * @param callback function from the caller to return result
 * @param store_id the unique id of the store
 * @returns true if successful, false otherwise
 */
export function db_decrease(dbcon: any, store_id: number, callback: any)
{
    var sql = "UPDATE Stores SET people_in_store = people_in_store - 1 \
                 WHERE store_id = ?";
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        if (err) throw err;
        // check whether the update was successful or not
        if (result.affectedRows == 1 && result.warningCount == 0) {
            callback(true);
        } else {
            callback(false);
        }
    });
}