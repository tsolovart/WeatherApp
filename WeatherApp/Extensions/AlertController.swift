//
//  AlertController.swift
//  WeatherApp
//
//  Created by Zaoksky on 06.06.2021.
//

import UIKit

extension ViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            tf.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Seatch", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                    // self.networkWeatherManager.fetchCurrentWeather(forCity: cityName) // информация по городу, но сделаем ее через closure (замыкания)
/* completionHandler - closure, который позволит нам передать название города
   Если cityName содержит несколько элементов, разделенным " ", то .split разъединяет их в [] и .joined соединяет между собой
*/
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
