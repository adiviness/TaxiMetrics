'use-strict';

// Description:
// tests for RideCost api


const apiEndpoint = require('./index.js');
const testUtils = require('../testUtils.js');

beforeAll(() => {
    testUtils.injectLocalSettings();
});

test('RideCost should return valid result code for green cabs', done => {
    let context = testUtils.context();
    let request = {
        query: {
            ride: 'green',
            pickup: 'Chinatown',
            dropoff: 'Astoria'
        }
    };

    context.done = function() {
        expect(context.res.status).toBe(200);
        expect(context.res.headers['Content-Type']).toBe('application/json');

        jsonResult = JSON.parse(context.res.body);

        done();
    }

    apiEndpoint(context, request);
});

test('RideCost should return failing result code for bad ride type', done => {
    let context = testUtils.context();
    let request = {
        query: {
            ride: 'shuttle',
            pickup: 'Chinatown',
            dropoff: 'Astoria'
        }
    };

    context.done = function() {
        expect(context.res.status).toBe(400);
        done();
    }

    apiEndpoint(context, request);
});

test('RideCost should return failing result code for missing ride param', done => {
    let context = testUtils.context();
    let request = {
        query: {
            pickup: 'Chinatown',
            dropoff: 'Astoria'
        }
    };

    context.done = function() {
        expect(context.res.status).toBe(400);
        done();
    }

    apiEndpoint(context, request);
});

test('RideCost should return failing result code for missing pickup param', done => {
    let context = testUtils.context();
    let request = {
        query: {
            ride: 'yellow',
            dropoff: 'Astoria'
        }
    };

    context.done = function() {
        expect(context.res.status).toBe(400);
        done();
    }

    apiEndpoint(context, request);
});

test('RideCost should return failing result code for missing dropoff param', done => {
    let context = testUtils.context();
    let request = {
        query: {
            ride: 'green',
            pickup: 'Chinatown',
        }
    };

    context.done = function() {
        expect(context.res.status).toBe(400);
        done();
    }

    apiEndpoint(context, request);
});
