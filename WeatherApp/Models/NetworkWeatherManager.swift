//
//  NetworkWeatherManager.swift
//  WeatherApp
//
//  Created by Zaoksky on 03.06.2021.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    // closure
    var onCompletion: ((CurrentWeather) -> Void)?
    // получение информации о погоде
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        case.coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        // запрос данных
        let task = session.dataTask(with: url) { data, response, error in
            // data = JSON
            if let data = data { 
                // объект currentWeather, обладающий св-вами СurrentWeather | self. - так как работаем внутри closure
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        // происходит запрос
        task.resume()
    }
    
    // распарсим JSON - складываем полуженные данные по модели CurrentWeather
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        // декодируем данные из JSON в наш формат
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
