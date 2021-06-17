//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Zaoksky on 31.05.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    // изменить название key
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct Weather: Codable {
    let id: Int
}
