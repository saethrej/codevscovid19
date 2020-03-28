import { stream } from "winston";

/* Project: CodeVsCovid-19
   Author:  saethrej
   Date:    28.03.2020
   Brief:   Library that takes care of DB queries and calculations via MySQL 
*/

// we require the mysql library
const mysql = require('mysql');


/** brief: initiates a database connection and returns connection object 
 * 
 * @returns connection object
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
 * @returns {number} number of stores in database
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
 * @param {*} pos the target location (long, lat)
 * @param {number} radius the radius to search for stores in [km]
 * @param {callback fn} callback function from the caller to return result
 * @returns JSON-object containing rows of the form {store_id, longitude, latitude}
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
 * @param pos JSON-object {long, lat}
 * @param rect JSON-object with 4 rows {up: {long, lat}, down ...}
 * @param callback function from the caller to return result
 * @returns JSON-object containing rows of the form {store_id, longitude, latitude} 
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
 * @param {*} store_id the unique id of the store
 * @param {callback fn} callback function from the caller to return result
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

/**
 * 
 * @param dbcon 
 * @param store_id 
 * @param callback 
 * @returns {number} amount of people in corresponding store
 */
export function db_getPeopleInStore(dbcon: any, store_id: number, callback: any)
{

}

/**
 * 
 * @param dbcon 
 * @param store_id 
 * @param reservation_id 
 * @param callback 
 * @returns {boolean} true if reservation is valid, false otherwise
 */
export function db_checkReservation(dbcon: any, store_id: number, reservation_id: any, callback: any)
{

}

/**
 * 
 * @param dbcon 
 * @param store_id 
 * @param callback 
 * @returns JSON-object containing rows of the form {Stores joined with OpeningHours}
 */
export function db_getStoreData(dbcon: any, store_id: number, callback: any)
{

}

/**
 * 
 * @param dbcon 
 * @param store_id 
 * @param date 
 * @param time 
 * @param email 
 * @param callback 
 * @returns JSON-object containing row of reservation if succesful, otherwise {}
 */
export function db_makeReservation(dbcon:any, store_id: number, date: string, time: string, email: string, callback:any) {

}





