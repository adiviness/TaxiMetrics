'use-strict';

// Description:
// tests for command line app

const lib = require('./lib.js');

test('can get list of boroughs', done => {
    lib.getBoroughs(function(err, res, body) {
        expect(err).toBe(null);
        expect(res.statusCode).toBe(200);
        expect(res.headers['content-type'].includes("application/json")).toBe(true);
        expect(body.length).toBe(7);
        expect(body).toContain("Brooklyn");
        expect(body).toContain("Manhattan");
        expect(body).toContain("Bronx");
        done();
    });
});

test('can get list of zones', done => {
    lib.getZones(function(err, res, body) {
        expect(err).toBe(null);
        expect(res.statusCode).toBe(200);
        expect(res.headers['content-type'].includes("application/json")).toBe(true);
        expect(body.length).toBeGreaterThan(200);
        expect(body).toContain("Chinatown");
        expect(body).toContain("Eastchester");
        expect(body).toContain("Glendale");
        done();
    });
});

test('can get zones for Manhattan', done => {
    lib.getZonesInBorough('Manhattan', function(err, res, body) {
        expect(err).toBe(null);
        expect(res.statusCode).toBe(200);
        expect(res.headers['content-type'].includes("application/json")).toBe(true);
        expect(body.length).toBeGreaterThan(0);
        expect(body).toContain("Battery Park");
        expect(body).toContain("Central Harlem");
        expect(body).toContain("Inwood");
        expect(body).not.toContain("Ocean Hill");
        expect(body).not.toContain("Homecrest");
        done();
    });
});

test('can get zones for Brooklyn', done => {
    lib.getZonesInBorough('Brooklyn', function(err, res, body) {
        expect(err).toBe(null);
        expect(res.statusCode).toBe(200);
        expect(res.headers['content-type'].includes("application/json")).toBe(true);
        expect(body.length).toBeGreaterThan(0);
        expect(body).toContain("Bath Beach");
        expect(body).toContain("Ocean Hill");
        expect(body).toContain("Homecrest");
        expect(body).not.toContain("Central Harlem");
        expect(body).not.toContain("Inwood");
        done();
    });
});

test("can't get taxi costs with bad taxi", done => {
    lib.getCostsForTaxi('red', 'Astoria', 'Astoria', function(err, res, body) {
        expect(res.statusCode).toBe(400);
        done();
    });
});


test("can't get taxi costs with bad zone", done => {
    lib.getCostsForTaxi('green', 'Ganymede', 'Astoria', function(err, res, body) {
        expect(res.statusCode).toBe(200);
        expect(body.length).toBe(0);
        done();
    });
});
