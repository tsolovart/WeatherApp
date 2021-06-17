//
//  ViewController.swift
//  WeatherApp
//
//  Created by Zaoksky on 30.05.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    var networkWeatherManager = NetworkWeatherManager()
    // lazy - вдруг пользователь не разрешит определять геопозицию, так не будем держать в памяти
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        // точность получения информации
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        // запрос разрешения. .plist (+ Privacy - Location When in Use - "We need your location data to provide weather information")
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [weak self] - лист захвата.
        // Чтобы понимать, что здесь нет цикла сильных ссылок, если со временем будет несколько экранов, и мы захотим избавится от экрана с closure
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        // пользватель отключил возможность делиться геопозицией, проверяем
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        // unowned - мы гарантируем, что self существует на момент завершения работы closure
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather) {
        
        // переносим поток в главную очередь
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.pressureLabel.text = weather.pressureString
            self.humidityLabel.text = weather.humidityString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.imageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // конечная позиция пользователя - это последний элемент []
        guard let location = locations.last else { return }
        // широта и долгота
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        // получаем погоду по текущему местоположению
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
