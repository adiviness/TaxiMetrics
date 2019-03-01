'use-strict'

// Description:
// - main functionality of command line app.
// - handles all http requests

const request = require('request');

// api url
const rootUrl = "http://taxi-metrics-api-austdi.azurewebsites.net/api/";

// api function keys
const apiKeys = {
    Zones: "RlEZxaW38i4Rq5jD0jP4mGQh1ocBMTZ9Sht3vRniGbi5IRJTqMi5BA==",
    Boroughs: "rH5EbDVFRn5l2Ve8mmc/Dp4XXdWSSOSGPfoQRb3TnhNLfjFApAS9yQ==",
    RideCost: "/AvdQCN7NzNdMVf9IByAXRHx6rLGhAaGw6vI7FPX/pdC2wgKJD9uaQ=="
};


// Description:
// - makes an http request for a json response.
// Arguments:
// - url - where to make the http request to
// - callback - function that's called when the request completes successfully
// Note: callback :: json -> void
function makeHttpCall(url, callback) {
    request(url, { json: true }, callback);
}

// Description:
// - calls the boroughs api
// Arguments:
// - callback - callback function of type a => err -> res -> body -> a
function getBoroughs(callback) {
    const functionKey = apiKeys['Boroughs'];
    const apiEndpoint = rootUrl + "boroughs?code=" + functionKey;
    makeHttpCall(apiEndpoint, callback);
}

// Description:
// - calls the zones api to get the zones in a specific borough and prints the result
// Arguments:
// - borough - the borough to fetch the zones for
// - callback - callback function of type a => err -> res -> body -> a
function getZonesInBorough(borough, callback) {
    const functionKey = apiKeys['Zones'];
    const apiEndpoint = `${rootUrl}zones?borough=${borough}&code=${functionKey}`;
    makeHttpCall(apiEndpoint, callback);
}

// Description:
// - calls the zones api to get all available zones
// Arguments:
// - callback - callback function of type a => err -> res -> body -> a
function getZones(callback) {
    const functionKey = apiKeys['Zones'];
    const apiEndpoint = rootUrl + "zones?code=" + functionKey;
    makeHttpCall(apiEndpoint, callback);
}

// Description:
// - calls the RideCost api to get list of ride costs between zones
// Arguments:
// - ride - type of taxi
// - pickup - pickup zone
// - dropoff - dropoff zone
// - callback - callback function of type a => err -> res -> body -> a
function getCostsForTaxi(ride, pickup, dropoff, callback)
{
    const functionKey = apiKeys['RideCost'];
    const apiEndpoint = rootUrl + `RideCost?ride=${ride}&pickup=${pickup}&dropoff=${dropoff}&code=${functionKey}`;
    makeHttpCall(apiEndpoint, callback);
}

module.exports = {
    getBoroughs,
    getZones,
    getZonesInBorough,
    getCostsForTaxi

}
