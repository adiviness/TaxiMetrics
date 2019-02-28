'use-strict';

// Description:
// - returns json encoded listing of unique zones in all boroughs.
// Arguments:
// - borough - if present, will return zones from only specified borough (optional)
module.exports = function (context, req) {

    const common = require('../common.js');
    const config = common.getConfig();

    const Connection = require('tedious').Connection;
    let connection = new Connection(config);

    common.hookContextDoneWithConnectionClose(context, connection);

    connection.on('connect', function(err) {
        if (err) {
            common.error(err, context);
        }
        else if (req.query.borough) {
            queryBoroughZones(req.query.borough);
        }
        else {
            queryUniqueZones();
        }
    });

    // Description:
    // - get list of all unique zones in all boroughs
    function queryUniqueZones() {
        common.query(context,
                     connection,
                     "select distinct zone from Zones",
                     function(columns) {
                         return columns[0].value;
                     });
    }

    // Description:
    // - get list of all zones within borough
    // Arguments:
    // - borough: borough to get zones from
    function queryBoroughZones(borough) {
        common.query(context,
                     connection,
                     `select distinct zone from Zones where borough='${borough}'`,
                     function(columns)
                     {
                         return columns[0].value;
                     });
    }
};
