
// Description:
// - returns json encoded listing of all unique boroughs
module.exports = function (context, req) {

    connection_setting = process.env["blah"];

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

    connection.on('connect', function(err) {
        if (err) {
            console.log(err);
            error(err);
        }
        else {
            queryBoroughs();
        }
    });

    // Description:
    // - get list of boroughs from database and return to caller
    function queryBoroughs() {
        boroughs = [];
        var request = new Request("select distinct borough from Zones",
                                  function(err, rowCount, rows)
        {
            if (err) {
                console.log(err);
                error(err);
            }
            else {
                context.res = {
                    body: JSON.stringify(boroughs),
                    headers: { "Content-Type": "application/json" }
                };
                context.done();
            }
        });

        request.on('row', function(columns) {
            boroughs.push(columns[0].value);
        });
        connection.execSql(request);
    }

    // Description:
    // - report error code back to caller
    // Arguments:
    // - err - the error that occurred.
    function error(err) {
        context.res = {
            body: err,
            status: 500
        }
        context.done();
    }
};
