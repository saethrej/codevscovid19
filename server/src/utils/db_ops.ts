import { stream } from "winston"
import { logger } from '../logger'

/* Project: CodeVsCovid-19
   Author:  saethrej
   Date:    28.03.2020
   Brief:   Library that takes care of DB queries and calculations via MySQL 
*/

// we require the mysql library
const mysql = require('mysql')


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
    })
    
    connection.connect((err: any) => {
        if (err) throw err
    })
    logger.info("Successfully connected to database.")
    return connection
}

/** brief: disconnects the server from the database
 * 
 * @param {*} dbcon the database connection
 */
function db_disconnect(dbcon: any)
{
    dbcon.end()
}

/** brief: returns the number of stores in the database
 * 
 * @param {*} dbcon the database connection
 * @param {*} callback function from the caller to return result
 * @returns {number} number of stores in database
 */
export function db_getNumStores(dbcon: any, callback: any)
{
    var sql = "SELECT count(*) FROM Stores"
    dbcon.query(sql, function(err: any, result: any, fields: any) {
        if (err) {
            throw err
        }
        return callback(result)
    })
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
               WHERE "
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
               WHERE longitude > ? AND longitude < ? AND latitude > ? AND latitude < ?"
    dbcon.query(sql, [rect.left.long, rect.right.long, rect.down.lat, rect.up.lat], function(err: any, result: any, fields: any) {
        if (err) throw err
        callback(result)
    })
}

/** brief: attempts to increment the store counter
 * 
 * @param {*} dbcon the database connection
 * @param {*} store_id the unique id of the store
 * @param {callback fn} callback function from the caller to return result
 * @returns true if successful, false otherwise
 * 
 * @description This function also increments the history database of the given store and date combination.
 */
export function db_increase(dbcon: any, store_id: number, callback: any)
{
    var newArray = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    var sql = "UPDATE Stores SET people_in_store = people_in_store + 1 \
                 WHERE store_id = ?"
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        if (err) {
            logger.error(err)
            callback(false)
            return
        }
        // if the query was successful, update the history database
        if (result.affectedRows == 1 && result.warningCount == 0) {

            // get current date
            var timezoneOffset = new Date().getTimezoneOffset() * 60000
            var d = new Date() // current, local timezone
            var date:string = (new Date(Date.now() - timezoneOffset)).toISOString().substr(0, 10) // also in current time-zone

            // check whether an entry in the history database already exists
            dbcon.query("SELECT * FROM History WHERE store_id = ? AND date = ?", [store_id, date], function(err: any, result: any, fields: any) {
                // if an error occurs here, only log it - we can live with a faulty history DB
                if (err) {
                    logger.error(err)
                    callback(true)
                    return
                }
                // if result is empty, then this is the first customer of the day in the store - create new entry
                if (result.length == 0) {
                    // add first customer of the day to the array
                    newArray[d.getHours()] += 1
                    dbcon.query("INSERT INTO History (store_id, date, customers) VALUES (?, ?, ?)", [store_id, date, JSON.stringify(newArray)], function(err: any, result: any, fields: any) {ichffasf
                        // if an error occurs here, only log it - we can live with a faulty history DB
                        if (err) {
                            logger.error(err)
                            callback(true)
                            return
                        }
                        callback(true)
                        return
                    })
                
                // the entry already exists: "update" it by getting current entry, unserializing it, updating the underlying array, serialize it back and update DB entry
                } else {
                    // get the customers array and update it
                    var array = JSON.parse(result[0]['customers'])
                    array[d.getHours()] += 1

                    // update the row in the database
                    dbcon.query("UPDATE History SET customers = ? WHERE store_id = ? AND date = ?", [JSON.stringify(array), store_id, date], function(err: any, result: any, fields: any) {
                        // if an error occurs here, only log it - we can live with a faulty history DB
                        if (err) {
                            logger.error(err)
                            callback(true)
                            return
                        }
                        // there's no point in further examining whether the operation was succesful here, as we execute callback(true) anyway
                        callback(true)
                        return
                    })

                }
            })
        
        // if the query was not succesfull, return false
        } else {
            callback(false)
            return
        }
    })
}

/** brief: attempts to decrement the store counter
 * 
 * @param {*} dbcon the database connection 
 * @param store_id the unique id of the store
 * @param callback function from the caller to return result
 * @returns true if successful, false otherwise
 */
export function db_decrease(dbcon: any, store_id: number, callback: any)
{
    var sql = "UPDATE Stores SET people_in_store = people_in_store - 1 \
                 WHERE store_id = ?"
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        if (err) {
            logger.error(err)
            callback(false)
            return
        }
        // check whether the update was successful or not
        if (result.affectedRows == 1 && result.warningCount == 0) {
            callback(true)
        } else {
            callback(false)
        }
    })
}

/** brief: returns the current number of people in the store
 * 
 * @param dbcon the database connection 
 * @param store_id id of the store
 * @param callback function from the caller to return result 
 * @returns {number} amount of people in corresponding store
 * 
 * @throws exception if the query fails 
 */
export function db_getPeopleInStore(dbcon: any, store_id: number, callback: any)
{
    var sql = "SELECT people_in_store FROM Stores WHERE store_id = ?"
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        if (err) {
            logger.error(err)
            throw err // throw error
        }
        callback(result[0]['people_in_store'])
    })
}

/** brief: checks whether a reservation is valid for the current time or not.
 *         the method allows a flexibility of +/- 10 minutes
 * 
 * @param dbcon the database connection
 * @param store_id id of the store
 * @param reservation_id id of the reservation (hash)
 * @param callback function from the caller to return result
 * @returns {boolean} true if reservation is valid, false otherwise
 */
export function db_checkReservation(dbcon: any, store_id: number, qr_hash: any, callback: any)
{
    // get current time and tolerance times
    var msSinceEpoch = Date.now()
    var upTolDate = new Date(msSinceEpoch + 600000)
    var loTolDate = new Date(msSinceEpoch - 600000)
    var upMin = upTolDate.getMinutes() < 10 ? "0" + upTolDate.getMinutes() : upTolDate.getMinutes()
    var loMin = loTolDate.getMinutes() < 10 ? "0" + loTolDate.getMinutes() : loTolDate.getMinutes()

    var upTime = "" + upTolDate.getHours() + upMin
    var loTime = "" + loTolDate.getHours() + loMin

    var sql = "SELECT * FROM Reservations2 \
                WHERE store_id = ? \
                AND qr_hash = ? \
                AND date = CURDATE() \
                AND time > ? \
                AND time < ?"

    dbcon.query(sql, [store_id, qr_hash, loTime, upTime], function(err: any, result: any, fields: any) {
        // return false in case an error occurred
        if (err) {
            logger.error(err)
            callback(false) 
            return
        }
        // return true if exactly one entry exists
        if (result.length == 1) {
            callback(true)
        } else {
            callback(false)
        }

    })
}

/** brief: returns the store data, i.e. its information and opening hours
 * 
 * @param dbcon the database connection
 * @param store_id id of the store
 * @param callback function from the caller to return result
 * @returns list containing 1 row of the form {Stores joined with OpeningHours}
 * 
 * @throws exception if sql query fails
 */
export function db_getStoreData(dbcon: any, store_id: number, callback: any)
{
    var sql = "SELECT * FROM Stores, Opening_Hours \
                WHERE Stores.store_id = ? \
                AND Stores.store_id = Opening_Hours.store_id"
    
    dbcon.query(sql, [store_id], function(err: any, result: any, fields: any) {
        // return false in case an error occurred
        if (err) {
            logger.error(err)
            throw err
        }
        // return the result of the query
        callback(result)
    })
}

/** brief: returns a list of reservations at a given store on a given date
 * 
 * @param dbcon the database connection
 * @param store_id the unique id of the store
 * @param date date of the reservation
 * @param callback function from the caller to return result
 * @returns array of reservations sorted by reservation time (from early to late)
 */
export function db_getStoreReservations(dbcon: any, store_id: number, date: string, callback: any)
{
    var sql = "SELECT * FROM Reservations2 WHERE store_id = ? AND date = ? \
                ORDER BY time ASC"
    
    dbcon.query(sql, [store_id, date], function(err: any, result: any, fields: any) {
        // if an error occurred, log it and return empty list
        if (err) {
            logger.error(err)
            callback([])
            return
        }
        // otherwise, return the list
        callback(result)
    })
}

/** brief: reserve an available slots for given store, date, and time.
 * 
 * @param dbcon the database connection
 * @param store_id the unique id of the store
 * @param date date of the reservation
 * @param time time (4 digit integer) of the reservation
 * @param callback function from the caller to return result
 * @returns array containing 1 row from Reservations table if successful, [] otherwise
 */
export function db_reserveReservationSlot(dbcon: any, store_id: number, date: string, time: number, callback: any)
{
    var sql = "INSERT INTO Reservations2 (store_id, date, time, confirmed) \
                VALUES (?, ?, ?, 0)"

    dbcon.query(sql, [store_id, date, time], function(err: any, result: any, fields: any) {
        if (err) {
            logger.error(err)
            callback([])
        }
        // check that only one row was inserted
        if (result.affectedRows == 1) {
            // retrieve the inserted row
            dbcon.query("SELECT * FROM Reservations2 WHERE reservation_id = ?", [result.insertId], function(err: any, result: any, fields: any) {
                // return an empty list if an error occurred in the second query
                if (err) {
                    logger.error(err)
                    callback([])
                }
                callback(result)
            })
        } else {
            callback([])
        }
    })
}

/** brief: confirm a reservation for given slot_id.
 * 
 * @param dbcon the database connection 
 * @param reservation_id the unique id of the reservation
 * @param {string} date date of the reservation
 * @param {number} time time of reservation as 4-digit integer 
 * @param callback function from the caller to return result
 * @returns JSON-object containing row of reservation including a slot_id, or [] if error occurred
 */
export function db_confirmReservation(dbcon: any, reservation_id: number, qr_hash :string, callback: any)
{
    var sql = "UPDATE Reservations2 SET qr_hash = ?, confirmed = 1\
                WHERE reservation_id = ? \
                AND confirmed = 0"
    
    dbcon.query(sql, [qr_hash, reservation_id], function(err: any, result: any, fields: any) {
        // when an error occurs, return empty list
        if (err) {
            logger.error(err)
            callback([])
            return
        }
        // check if it only affected one row
        if (result.affectedRows == 1) {
            // perform new query to retrieve the reservation row
            dbcon.query("SELECT * FROM Reservations2 WHERE reservation_id = ?", [reservation_id], function(err: any, result: any, fields: any) {
                // return an empty list if an error occurred in the second query
                if (err) {
                    logger.error(err)
                    callback([])
                }
                callback(result)
            })
        } else {
            callback([]) // return empty array
        }
    })
}

/** brief: checks whether a user's claimed credentials exist in the databse, returns true if that's the case and false otherwise
 * 
 * @param dbcon the database connection
 * @param {number} store_id the id of the store where the user (i.e. security personnel) logs in from
 * @param {string} username the (unique) username that the user provides
 * @param {string} pw_hash hash(password) or hash(username||password) 
 * @param callback function from the caller to return result
 * @returns {boolean} true if credentials are valid for given store, false otherwise
 */
export function db_checkCredentials(dbcon: any, store_id: number, username: string, pw_hash: string, callback: any)
{
    var sql = "SELECT * FROM Credentials WHERE store_id = ? AND username = ? AND hash = ?"

    dbcon.query(sql, [store_id, username, pw_hash], function(err: any, result: any, fields: any) {
        // if an error occurs, log it and return false
        if (err) {
            logger.error(err)
            callback(false)
            return
        }
        // check if exactly one such entry exists
        if (result.length == 1) {
            callback(true)
        } else {
            callback(false)
        }
    })
}

/** brief: returns historic data for the desired store and date
 * 
 * @param dbcon the database connection
 * @param store_id the id of the store to retrieve historic data
 * @param date the desired date for the historic data
 * @param callback function from the caller to return result
 * @returns a list containing a single object of type {store_id, date, customers=[count(timeslot1), count(timeslot2), count(timeslot3), ...]} 
 * where the inner array is of length 24, [] if invalid query
 */
export function db_getDailyHistory(dbcon: any, store_id: number, date: string, callback: any) 
{
    var sql = "SELECT * FROM History WHERE store_id = ? AND date = ?"

    dbcon.query(sql, [store_id, date], function(err: any, result: any, fields: any) {
        // return empty list if error occurred during query
        if (err) {
            logger.error(err)
            callback([])
            return
        }

        // return result if and only if one such entry was found
        if (result.length == 1) {
            callback(result)
        } else {
            callback([])
        }
    })
}
