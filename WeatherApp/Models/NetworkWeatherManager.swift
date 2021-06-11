//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Zaoksky on 03.06.2021.
//

import Foundation

struct NetworkWeatherManager {
    func fetchCurrentWeather(forCity city: String) {
        let urlString  = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
            // запрос данных
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8) // какие данные у нас хранятся
                print(dataString!)
            }
        }
            // происходит запрос
        task.resume()
    }
}
