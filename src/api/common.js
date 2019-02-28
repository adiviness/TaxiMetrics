'use-strict';

// Description:
// - Utilities that are common amoung the various api endpoints

// Description:
// - get database config
function getConfig() {
    return {
        userName: process.env["DbUsername"],
        password: process.env["DbPassword"],
        server: process.env["DbServer"],
        options: {
            database: process.env["DbDatabase"],
            encrypt: true,
        }
    };
}

// Description:
// - hooks the context.done() function with closing the database connection first
// Arguments:
// - context - the context to hook
// - connection - the connection to close
function hookContextDoneWithConnectionClose(context, connection) {
    let doneFn = context.done;
    context.done = function() {
        context.log("closing connection");
        connection.close();
        doneFn();
    }
}


// Description:
// - report error code back to caller
// Arguments:
// - err - the error that occurred.
// - context - the context for the request
// - status - the http status code to return. defaults to 500.
function error(err, context, status = 500) {
    context.log(err);
    context.res = {
        body: err,
        status: status
    }
    context.done();
}

// Description:
// - perform database query on connection and report result to context
// Arguments:
// - context - the context for the request
// - connection - the sql database connection
// - queryString - the sql query to execute
// - rowProcessFunc - a function that takes in a row of data and returns
// data intended to be aggragated for context return.
// Note : rowProcessFunc :: Row -> a
function query(context, connection, queryString, rowProcessFunc) {
    const Request = require('tedious').Request;
    let data = [];
    let request = new Request(queryString, function(err, rowCount, rows) {
        if (err) {
            error(err, context);
        }
        else {
            context.res = {
                status: 200,
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

module.exports = {
    getConfig,
    hookContextDoneWithConnectionClose,
    error,
    query
}
