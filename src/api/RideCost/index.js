'use-strict';

// Description:
// - returns json encoded listing of costs of a particular type
// Argements:
// - ride - may be one of [green, yellow]
// - pickup - pickup location zone
// - dropoff - dropoff location zone
module.exports = function (context, req) {

    const common = require('../common.js');

    // verify that we have the required arguments
    if (!req.query.pickup)
    {
        common.error("pickup param missing!", context);
    }
    if (!req.query.dropoff)
    {
        common.error("dropoff param missing!", context);
    }
    if (!req.query.ride)
    {
        common.error("ride param missing!", context);
    }

    // verify that arguments have valid values
    const ride = req.query.ride;
    if (!['green', 'yellow'].includes(ride))
    {
        common.error("ride param is invalid!", context);
    }

    const config = common.getConfig();
    const Connection = require('tedious').Connection;
    let connection = new Connection(config);

    connection.on('connect', function(err) {
        context.log("conection")
        if (err) {
            common.error(err, context);
        }
        else {
            queryCost();
        }
    });

    // Description:
    // - build query based on request params
    function buildQuery() {
        const pickup = req.query.pickup;
        const dropoff = req.query.dropoff;
        let table = "badTable";

        switch (ride)
        {
        case 'green':
            table = 'GreenCab';
            break;
        case 'yellow':
            table = 'YellowCab';
            break;
        default:
            common.error("can't build query", context);
            break;
        }
        return `
select top 1000 total_amount from ${table}
where pickup_location_id =
(select top 1 location_id from Zones where Zones.zone = '${pickup}') AND
dropoff_location_id =
(select top  1 location_id from Zones where Zones.zone = '${dropoff}') `;
    }

    // Description:
    // - get list of taxi costs between provided locations
    function queryCost() {
        common.query(context,
                     connection,
                     buildQuery(),
                     function(columns) {
                         return columns[0].value;
                     });
    }
};
