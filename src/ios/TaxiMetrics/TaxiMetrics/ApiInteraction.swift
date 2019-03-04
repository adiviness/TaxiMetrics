//
//  ApiInteraction.swift
//  TaxiMetrics
//
//  Created by Austin Diviness on 3/1/2019.
//  Copyright © 2019 Austin Diviness. All rights reserved.
//

import Foundation

// Description:
// - abstracts away all direct communication with the api endpoints.
class ApiInteraction {
    // api url
    let rootUrl: String = "https://taxi-metrics-api-austdi.azurewebsites.net/api/";

    // api function keys
    let apiKeys = [
        "Zones": "RlEZxaW38i4Rq5jD0jP4mGQh1ocBMTZ9Sht3vRniGbi5IRJTqMi5BA==",
        "Boroughs": "rH5EbDVFRn5l2Ve8mmc/Dp4XXdWSSOSGPfoQRb3TnhNLfjFApAS9yQ==",
        "RideCost": "/AvdQCN7NzNdMVf9IByAXRHx6rLGhAaGw6vI7FPX/pdC2wgKJD9uaQ=="
    ];

    // Description:
    // - makes http api query to get borough list
    // Arguments:
    // - funcParam - callback function
    func queryBoroughs(funcParam: @escaping ([String]) -> Void) {
        let apiKey: String = apiKeys["Boroughs"]!;
        let url = URL(string: "\(rootUrl)boroughs?code=\(apiKey)")!;

        httpQuery(url: url, funcParam: funcParam);
    }

    // Description:
    // - makes http api querey to get zones in borough
    // Arguments:
    // - borough - the borough to get the zones for
    // - funcParam - callback function
    func queryZones(borough: String, funcParam: @escaping (String, [String]) -> Void) {
        let apiKey: String = apiKeys["Zones"]!;
        let urlString = "\(rootUrl)zones?borough=\(borough)&code=\(apiKey)";
        guard let url = URL(string: urlString) else { return };

        httpQuery(url: url, key: borough, funcParam: funcParam);
    }

    // Description:
    // - makes https api query to get the list of costs for a particular taxi company route
    // Arguments:
    // - taxi - the taxi type
    // - pickup - the pickup zone
    // - dropoff - the dropoff zone
    // - funcParam - callback function
    func queryRideCost(taxi: String, pickup: String, dropoff: String, funcParam: @escaping ([String]) -> Void) {
        let apiKey: String = apiKeys["Zones"]!;
        let urlString = "\(rootUrl)Ridecost?ride=\(taxi)&dropoff=\(dropoff)&pickup=\(pickup)&code=\(apiKey)";
        print(urlString);
        guard let url = URL(string: urlString) else { return; };
        print (url);
        httpQuery(url: url, funcParam: funcParam);
    }

    // Description:
    // - makes an http query and deserializes the json result
    // Arguments:
    // - url - the url to make the query to
    // - funcParam - callback function
    func httpQuery(url: URL, funcParam: @escaping ([String]) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return };
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String];
                funcParam(parsedData);
            }
            catch let err {
                print(err);
            }
        };
        task.resume();
    }

    // Commentary: I'm not thrilled with having an overload of httpQuery(), I would've
    // preferred to have the callback function store the data of the borough that was associated with
    // the zones api calls. But I couldn't figure out how swift handles closures in time... so this
    // got me unblocked for now.

    // Description:
    // - makes an http query and deserializes the json result
    // Arguments:
    // - url - the url to make the query to
    // - key - the key for the data type being queried
    // - funcParam - callback function
    func httpQuery(url: URL, key: String, funcParam: @escaping (String, [String]) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return };
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data) as! [String];
                funcParam(key, parsedData);
            }
            catch let err {
                print(err);
            }
        };
        task.resume();
    }
}
