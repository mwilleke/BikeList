//
//  NetworkApi.swift
//  BikeList
//
//  Created by Matthew Willeke on 1/27/19.
//  Copyright © 2019 Matthew Willeke. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NetworkApi {
    static func getNetworkContentFromApi(completion: @escaping ([Network]?) -> Void) {
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error")
                    completion(nil)
                    return
            }

            let networks = JSON(value)["networks"].arrayValue.map { json in
                Network(id: json["id"].stringValue, companyName: json["company"][0].stringValue, city: json["location"]["city"].stringValue, country: json["location"]["country"].stringValue, latitude: json["location"]["latitude"].doubleValue, longitude: json["location"]["longitude"].doubleValue)
            }
            completion(networks)
        }
    }
}
