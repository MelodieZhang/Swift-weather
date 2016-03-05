//
//  WeatherResponse.swift
//  Swift Weather
//
//  Created by Melodie on 16/2/5.
//  Copyright © 2016年 Melodie. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

class WeatherResponse: Mappable {
    var name: String?
    var weatherId: Int?
    var weatherDescpt: String?
    var temp: Double?
    var humidity: Int?
    var windSpeed: Int?
    var sunrise: Int?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        name            <- map["name"]
        weatherId       <- map["weather.0.id"]
        weatherDescpt   <- map["weather.0.main"]
        temp            <- map["main.temp"]
        humidity        <- map["main.humidity"]
        windSpeed       <- map["wind.speed"]
        sunrise         <- map["sys.sunrise"]
        
    }
}

