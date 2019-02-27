
// Description:
// - Utilities that are common amoung the various api endpoints
module.exports = {
    // Description:
    // - get database config
    getConfig: function() {
        return {
            userName: process.env["DbUsername"],
            password: process.env["DbPassword"],
            server: process.env["DbServer"],
            options: {
                database: process.env["DbDatabase"],
                encrypt: true,
            }
        };
    },

    // Description:
    // - report error code back to caller
    // Arguments:
    // - err - the error that occurred.
    // - context - the context for the request
    error: function(err, context) {
        context.log(err);
        context.res = {
            body: err,
            status: 500
        }
        context.done();
    },

    // Description:
    // - perform database query on connection and report result to context
    // Arguments:
    // - context - the context for the request
    // - connection - the sql database connection
    // - queryString - the sql query to execute
    // - rowProcessFunc - a function that takes in a row of data and returns
    // data intended to be aggragated for context return.
    // Note : rowProcessFunc :: Row -> a
    query: function(context, connection, queryString, rowProcessFunc) {
        var Request = require('tedious').Request;
        data = [];
        var request = new Request(queryString, function(err, rowCount, rows) {
            if (err) {
                error(err, context);
            }
            else {
                context.res = {
                    body: JSON.stringify(data),
                    headers: { "Content-Type": "application/json" }
                };
                context.done();
            }
        });

        request.on('row', function(columns) {
            data.push(rowProcessFunc(columns));
        });
        connection.execSql(request);
    }
}
