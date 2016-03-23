//
//  ViewController.swift
//  Swift Weather
//
//  Created by Melodie on 16/1/23.
//  Copyright © 2016年 Melodie. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireObjectMapper

public protocol TransformType {
    typealias Object
    typealias JSON
    
    func transformFromJSON(value: AnyObject?) -> Object?
    func transformToJSON(value: Object?) -> JSON?
}



class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidityPercent: UILabel!

    @IBOutlet weak var locationToImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLabelToTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // change layout constraints
        // if screen is iphone6 or bigger, add extra top space
        let size = UIScreen.mainScreen().bounds.size
        if size.height > 1136/2.0 {
            self.topLabelToTopConstraint.constant = 36
            self.locationToImageConstraint.constant = 44
        }


        
        locationManager.delegate = self
        
        //初始化精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //获得地理位置权限
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    
    //有地理位置更新后会回传
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count-1] as CLLocation
        
        if(location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            self.updateWeatherInfo(location.coordinate.latitude, longtitude: location.coordinate.longitude)

            locationManager.stopUpdatingLocation()
        }
    }
    
    
    func updateWeatherInfo(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {

        let url = "http://api.openweathermap.org/data/2.5/weather"
        
        Alamofire.request(.GET, url, parameters: ["lat":latitude, "lon":longtitude, "cnt":0, "appid": "b7282b40e9db1bc04cb2a422d3d5b12e"]).responseObject{ (response: Response<WeatherResponse, NSError>) in
            
            if let weatherResponse = response.result.value {
                print(weatherResponse.name)
                print(weatherResponse.temp)
                print(weatherResponse.weatherDescpt)
                print(weatherResponse.humidity)
                print(weatherResponse.weatherId)
                print(weatherResponse.sunrise)
                self.updateUISuccess(weatherResponse)
            }
        
        }
    
    }
    
    func updateUISuccess(weatherObject: WeatherResponse) {
        
        //天气
        self.condition.text = weatherObject.weatherDescpt?.uppercaseString
        
        
        //城市
        self.location.text = weatherObject.name!
        
        //天气图标
        let weatherId = weatherObject.weatherId!
        self.updateWeatherIcon(weatherId)
        
        //温度
        if let tempResult = weatherObject.temp {
            let temp = Int(round(tempResult - 273.15))
            self.temperature.text = "\(temp)°"
        }
        
        //日出时间
        let unixTime = weatherObject.sunrise!
        let utcTime = changeUTCtoDate(unixTime)
        self.sunriseTime.text = utcTime as String
        
        
        
        //风速
        self.windSpeed.text = "\(weatherObject.windSpeed!) km/h"
        
        //湿度
        self.humidityPercent.text = "\(weatherObject.humidity!)%"
        
        
    }


    
    func updateWeatherIcon(weatherId: Int) {
        switch weatherId {
        case 200..<300:
            self.icon.image = UIImage(named: "thunderstorm")
        case 300..<400:
            self.icon.image = UIImage(named: "drizzle")
        case 500..<600:
            self.icon.image = UIImage(named:"rainy")
        case 700..<800:
            self.icon.image = UIImage(named: "snowy")
        case 800:
            self.icon.image = UIImage(named: "sunny")
        case 801..<805:
            self.icon.image = UIImage(named: "cloudy")
        default:
            self.icon.image = UIImage(named: "default")
            break
        }
    }
    
    //时间戳 时间转换
    func changeUTCtoDate(UTCString:Int) -> NSString{
        let sunStr = NSString(format: "%d", UTCString)
        let timer:NSTimeInterval = sunStr.doubleValue
        let data = NSDate(timeIntervalSince1970: timer)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "HH:mm"
        let str:NSString = formatter.stringFromDate(data)
        return str
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    

    


}

