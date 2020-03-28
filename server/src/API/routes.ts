import { strict } from "assert";

module.exports = function (app: any) {
    var counter = require('./counter');

    // todoList Routes

    app.route('/counterup')
        .get(counter.up);

    app.route('/counterdown')
        .get(counter.down);

    var QRCode = require('./QRCode');

    app.route('/checkQRCode')
        .post(QRCode.check);
    
    var stores = require('./stores');

    app.route('/getLocations')
        .get(stores.locations);

    app.route('/getStoreData/:storeId')
        .get(stores.dat);

    var reservations = require('./reservations');

    app.route('/preReservation')
        .post(reservations.pre);
    
    app.route('/getReservation')
        .post(reservations.confirm);

};