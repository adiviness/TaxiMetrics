'use-strict';

// Description:
// tests for GetBoroughs api


const apiEndpoint = require('./index.js');
const testUtils = require('../testUtils.js');

beforeAll(() => {
    testUtils.injectLocalSettings();
});

test('GetBoroughs should return valid result code', done => {
    let context = testUtils.context();
    let request = {};

    context.done = function() {
        expect(context.res.status).toBe(200);
        expect(context.res.headers['Content-Type']).toBe('application/json');

        jsonResult = JSON.parse(context.res.body);
        expect(jsonResult).toHaveLength(7);
        // test a few values to make sure the data is what we expect
        expect(jsonResult).toContain("Bronx");
        expect(jsonResult).toContain("Manhattan");
        expect(jsonResult).toContain("Brooklyn");

        done();
    }

    apiEndpoint(context, request);

});
