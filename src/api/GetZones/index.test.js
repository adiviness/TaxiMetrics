'use-strict';

// Description:
// tests for GetZones api


const apiEndpoint = require('./index.js');
const testUtils = require('../testUtils.js');

beforeAll(() => {
    testUtils.injectLocalSettings();
});

test('GetZones should return valid response data', done => {
    let context = testUtils.context();
    let request = { query: {} };

    context.done = function() {
        expect(context.res.status).toBe(200);
        expect(context.res.headers['Content-Type']).toBe('application/json');

        jsonResult = JSON.parse(context.res.body);
        expect(jsonResult.length).toBeGreaterThan(200);
        // test a few values to make sure the data is what we expect
        expect(jsonResult).toContain("Astoria");
        expect(jsonResult).toContain("Bronx Park");
        expect(jsonResult).toContain("Canarsie");
        // shouldn't contain any boroughs
        expect(jsonResult).not.toContain("Brooklyn");

        done();
    }

    apiEndpoint(context, request);
});

test('GetZones should return zones in specific boroughs', done => {
    let context = testUtils.context();
    let request = { query: { borough: 'Manhattan' } };

    context.done = function() {
        expect(context.res.status).toBe(200);
        expect(context.res.headers['Content-Type']).toBe('application/json');

        jsonResult = JSON.parse(context.res.body);
        expect(jsonResult.length).toBeGreaterThan(50);
        // test a few values to make sure the data is what we expect
        expect(jsonResult).toContain("Inwood");
        expect(jsonResult).toContain("Chinatown");
        expect(jsonResult).toContain("Midtown East");
        // shouldn't contain any zones from other boroughs
        expect(jsonResult).not.toContain("Bronx Park");

        done();
    }

    apiEndpoint(context, request);
});
