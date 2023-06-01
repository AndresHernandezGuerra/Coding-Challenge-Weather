//
//  WeatherViewController+Extensions.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//

import UIKit
import CoreLocation

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let city = textField.text {
            getWeatherData(for: city)
            UserDefaults.standard.set(city, forKey: "LastSearchedCity")
        }
        return true
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self?.searchTextField.text = city
                        self?.getWeatherData(for: city)
                        UserDefaults.standard.set(city, forKey: "LastSearchedCity")
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
