'use-strict'

// Description:
// - Entrypoint for command line app
// - handles arg parsing and routing to lib.js

const lib = require('./lib.js');

// Description:
// - prints the results of an http api request
// Arguments:
// - json - array to print out
function printResults(json) {
    for (let i = 0; i < json.length; i += 1) {
        console.log(json[i]);
    }
}

// Description:
// - prints result data if successful http request
// Arguments:
// - err - possible error data
// - res - http result data
// - body - http result body
function handleResult(err, res, body) {
    if (err) {
        console.log(err);
        process.exit(1);
    }
    else {
        printResults(body);
    }
}

// Description:
// - prints the help text
function printHelp() {
    // Commentary: I'm not super thrilled how cmdRoot is using the full path
    // to node and the js file, it's distracting.
    const cmdRoot = `${process.argv[0]} ${process.argv[1]}`;
    console.log("Usage:");
    console.log(`${cmdRoot} boroughs = get list of boroughs`);
    console.log(`${cmdRoot} zones = get list of zones`);
    console.log(`${cmdRoot} zones <borough> = get list of zones in borough`);
    console.log(`${cmdRoot} ridecost <ride> <pickup> <dropoff> = get list of taxi costs from pickup to dropoff. ride may be green or yellow`);
    console.log(`${cmdRoot} average <ride> <pickup> <dropoff> = gets average of taxi costs from pickup to dropoff. ride may be green or yellow`);
    console.log(`${cmdRoot} whichbest <pickup> <dropoff> = determines which cab is cheaper between pickup and dropoff`);
}

// Description:
// - calculates the average of data in array
// Arguments:
// - data - array of numbers to average
// Return Value:
// - average value
function average(data) {
    let sum = 0;
    for(let i = 0; i < data.length; i += 1) {
        sum += data[i];
    }
    return sum / data.length;
}

// Description:
// - calculates the average of data from http response
// Arguments:
// - err - possible error data
// - res - http result data
// - body - http result body
// Return Value:
// - average value
function calculateAverage(err, res, body) {
    if (err) {
        console.log(err);
        process.exit(1);
    }
    else {
        return average(body);
    }
}

// Description:
// - determines which taxi is the cheapest between pickup and dropoff
// Arguments:
// - pickup - pickup zone
// - dropoff - dropoff zone
function calculateBestTaxi(pickup, dropoff) {
    let greenCost = 0;
    let yellowCost = 0;
    lib.getCostsForTaxi('green', pickup, dropoff, function(err, res, body) {
        greenCost = calculateAverage(err, res, body);
        lib.getCostsForTaxi('yellow', pickup, dropoff, function(err, res, body) {
            yellowCost = calculateAverage(err, res, body);
            if (greenCost < yellowCost) {
                console.log('green cab is cheaper');
            }
            else if (yellowCost < greenCost) {
                console.log('yellow cab is cheaper');
            }
            else {
                console.log('green and yellow cabs cost the same');
            }
        });
    });
}


// Commentary:
// I'm not super thrilled with the switch block below, I think it would be
// better if I used some sort of arg parsing lib, if I had more time...

if (process.argv.length <= 2) {
    printHelp();
    process.exit();
}
arg = process.argv[2];
switch (arg) {
    case 'boroughs':
        lib.getBoroughs(handleResult);
            break;
    case 'zones':
        if (process.argv.length > 3) {
            const borough = process.argv[3];
            lib.getZonesInBorough(borough, handleResult);
        }
        else {
            lib.getZones(handleResult);
        }
        break;
    case 'ridecost': {
        if (process.argv.length < 6) {
            printHelp();
            process.exit(1);
        }
        const ride = process.argv[3];
        const pickup = process.argv[4];
        const dropoff = process.argv[5];
        lib.getCostsForTaxi(ride, pickup, dropoff, handleResult);
        break;
    }
    case 'average': {
        if (process.argv.length < 6) {
            printHelp();
            process.exit(1);
        }
        const ride = process.argv[3];
        const pickup = process.argv[4];
        const dropoff = process.argv[5];
        lib.getCostsForTaxi(ride, pickup, dropoff, function(err, res, body) {
            console.log(calculateAverage(err, res, body));
        });
        break;
    }
    case 'whichbest': {
        const pickup = process.argv[3];
        const dropoff = process.argv[4];
        calculateBestTaxi(pickup, dropoff)
        break;
    }
    case 'help':
        printHelp();
        break;
    default:
        printHelp();
        process.exit(1);
}
