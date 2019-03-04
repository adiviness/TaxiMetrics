//
//  ApiInteraction.swift
//  TaxiMetrics
//
//  Created by Austin Diviness on 3/1/2019.
//  Copyright © 2019 Austin Diviness. All rights reserved.
//

import Foundation

class ApiInteraction {
    // api url
    let rootUrl: String = "https://taxi-metrics-api-austdi.azurewebsites.net/api/";

    // api function keys
    let apiKeys = [
        "Zones": "RlEZxaW38i4Rq5jD0jP4mGQh1ocBMTZ9Sht3vRniGbi5IRJTqMi5BA==",
        "Boroughs": "rH5EbDVFRn5l2Ve8mmc/Dp4XXdWSSOSGPfoQRb3TnhNLfjFApAS9yQ==",
        "RideCost": "/AvdQCN7NzNdMVf9IByAXRHx6rLGhAaGw6vI7FPX/pdC2wgKJD9uaQ=="
    ];

    func queryBoroughs(funcParam: @escaping ([String]) -> Void) {
        let apiKey: String = apiKeys["Boroughs"]!;
        let url = URL(string: "\(rootUrl)boroughs?code=\(apiKey)")!;

        httpQuery(url: url, funcParam: funcParam);
    }

    func queryZones(borough: String, funcParam: @escaping (String, [String]) -> Void) {
        let apiKey: String = apiKeys["Zones"]!;
        let urlString = "\(rootUrl)zones?borough=\(borough)&code=\(apiKey)";
        guard let url = URL(string: urlString) else { return };

        httpQuery(url: url, key: borough, funcParam: funcParam);
    }

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
