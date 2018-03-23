//
//  CityWeatherInfo.swift
//  WeatherApp
//
//  Created by Arvind Singh on 23/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import Foundation

struct CityWeatherInfo : Codable {
    
    var id: Int
    var name: String
    var main: Main
    var coord: Coord
    var visibility: Int
    var wind: Wind
    var sys: Sys
    var dt: Double
    var weather: [Weather]
    var clouds: Clouds
}

struct Clouds: Codable {
    var all:Int
}

struct Sys: Codable {
    var country: String
    var sunrise: Double
    var sunset: Double
}

struct Wind: Codable {
    var speed: Float
    var deg: Float
}

struct Coord: Codable {
    var lon: Float
    var lat: Float
}
struct Main: Codable{
    
    var temp: Float
    var pressure: Float
    var humidity: Float
    var temp_min: Float
    var temp_max: Float
    
}

struct Weather: Codable{
    
    var id: Int
    var main: String
    var description: String
    var icon: String
    
}
