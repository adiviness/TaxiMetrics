
// Descriptions:
// - returns json encoded listing of unique zones in all boroughs.
// Arguments:
// - borough - if present, will return zones from only specified borough
module.exports = function (context, req) {

    var queryAllZones = true;
    if (req.query.borough) {
        queryAllZones = false;
    }

    var tedious = require('tedious');
    var Connection = tedious.Connection;
    var Request = tedious.Request;

    var config = {
        userName: process.env["DbUsername"],
        password: process.env["DbPassword"],
        server: process.env["DbServer"],
        options: {
            database: process.env["DbDatabase"],
            encrypt: true,
        }
    };

    var connection = new Connection(config);

    connection.on('connect', function(err)
                  {
                      if (err) {
                          error(err);
                      }
                      else if (queryAllZones) {
                          queryUniqueZones();
                      }
                      else {
                          queryBoroughZones(req.query.borough);
                      }
                  });

    // Description:
    // - get list of all unique zones in all boroughs
    function queryUniqueZones() {
        zones = [];
        var request = new Request("select distinct zone from Zones",
                                 function(err, rowCount, rows)
        {
            if (err) {
                error(err);
            }
            else {
                context.res = {
                    body: JSON.stringify(zones),
                    headers: { "Content-Type": "application/json" }
                };
                context.done();
            }
        });

        request.on('row', function(columns) {
            zones.push(columns[0].value);
        });
        connection.execSql(request);
    }

    // Description:
    // - get list of all zones within borough
    // Arguments:
    // - borough: borough to get zones from
    function queryBoroughZones(borough)
    {
        zones = [];
        var request = new Request(`select distinct zone from Zones where borough='${borough}'`,
                                 function(err, rowCount, rows)
        {
            if (err) {
                error(err)
            }
            else {
                context.res = {
                    body: JSON.stringify(zones),
                    headers: { "Content-Type": "application/json" }
                };
                context.done();
            }
        });

        request.on('row', function(columns) {
            zones.push(columns[0].value);
        });
        connection.execSql(request);
    }

    // Description:
    // - report error code back to caller
    // Arguments:
    // - err - the error that occurred.
    function error(err) {
        context.log(err);
        context.res = {
            body: err,
            status: 500
        }
        context.done();
    }
};
