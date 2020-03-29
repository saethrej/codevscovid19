module.exports = function (app: any) {
    var counter = require('./counter')

    // todoList Routes

    app.route('/counterup/:storeId')
        .get(counter.up)

    app.route('/counterdown/:storeId')
        .get(counter.down)

    app.route('/getcounter/:storeId')
        .get(counter.value)

    var QRCode = require('./QRCode')

    app.route('/checkQRCode')
        .post(QRCode.check)
    
    var stores = require('./stores')

    app.route('/getLocations')
        .post(stores.locations)

    app.route('/getStoreData/:storeId')
        .get(stores.dat)

    var reservations = require('./reservations')

    app.route('/getavailableReservation')
        .post(reservations.available)

    app.route('/reserveReservation')
        .post(reservations.reserve)
    
    app.route('/confirmReservation')
        .post(reservations.confirm)
}