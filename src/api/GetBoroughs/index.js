
// Description:
// - returns json encoded listing of all unique boroughs
module.exports = function (context, req) {

    var common = require('../common.js');
    var config = common.getConfig();

    var Connection = require('tedious').Connection;
    var connection = new Connection(config);

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
