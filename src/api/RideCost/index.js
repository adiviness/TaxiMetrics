
// Description:
// - returns json encoded listing of costs of a particular type
// Argements:
// - ride - may be one of [green, yellow]
// - pickup - pickup location zone
// - dropoff - dropoff location zone
module.exports = function (context, req) {

    var common = require('../common.js');

    // verify that we have valid arguments
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
    var ride = req.query.ride;
    if (!['green', 'yellow'].includes(ride))
    {
        common.error("ride param is invalid!", context);
    }

    var config = common.getConfig();
    var Connection = require('tedious').Connection;
    var connection = new Connection(config);

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
        var pickup = req.query.pickup;
        var dropoff = req.query.dropoff;
        var table = "badTable";

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
select ${table}.total_amount from ${table}
join Zones a on ${table}.pickup_location_id = a.location_id
join Zones b on ${table}.dropoff_location_id = b.location_id
where a.Zone = '${req.query.pickup}' and b.Zone = '${req.query.dropoff}'`
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
