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
    let rootUrl: String = "http://taxi-metrics-api-austdi.azurewebsites.net/api/";

    // api function keys
    let apiKeys = [
        "Zones": "RlEZxaW38i4Rq5jD0jP4mGQh1ocBMTZ9Sht3vRniGbi5IRJTqMi5BA==",
        "Boroughs": "rH5EbDVFRn5l2Ve8mmc/Dp4XXdWSSOSGPfoQRb3TnhNLfjFApAS9yQ==",
        "RideCost": "/AvdQCN7NzNdMVf9IByAXRHx6rLGhAaGw6vI7FPX/pdC2wgKJD9uaQ=="
    ];

}
