'use-strict';

// Description:
// - returns json encoded listing of all unique boroughs
module.exports = function (context, req) {

    const common = require('../common.js');
    const config = common.getConfig();

    const Connection = require('tedious').Connection;
    let connection = new Connection(config);

    common.hookContextDoneWithConnectionClose(context, connection);

    connection.on('connect', function(err) {
        if (err) {
            error(err);
        }
        else {
            queryBoroughs();
        }
    });

    // Description:
    // - get list of boroughs from database and return to caller
    function queryBoroughs() {
        common.query(context,
                     connection,
                     "select distinct borough from Zones",
                     function(columns) {
                         return columns[0].value;
                     });
    };
};
