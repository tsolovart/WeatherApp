//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Zaoksky on 06.06.2021.
//

import Foundation
import UIKit

struct CurrentWeather {
    let cityName: String
    
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    let pressure: Int
    var pressureString: String {
        return "\(pressure) мм"
    }
    
    let humidity: Int
    var humidityString: String {
        return "\(humidity) %"
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return "\(String(format: "%.0f", feelsLikeTemperature))˚C"
    }
    
    let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        pressure = currentWeatherData.main.pressure
        humidity = currentWeatherData.main.humidity
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionCode = currentWeatherData.weather.first!.id
    }
}
