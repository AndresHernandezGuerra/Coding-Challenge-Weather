//
//  NetworkingManager.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//

import Foundation
import UIKit

class NetworkingManager {
    private let apiKey = "06e94b7ce02b23e801d45339595ef901"
    
    // MARK: - Weather Data Download
    
    func getWeatherData(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        // Prepare the API URL for weather data retrieval
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=\(apiKey)"
        
        // Create a URL from the constructed URL string
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform a URLSession data task to fetch weather data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle network errors
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    // Decode the JSON response into WeatherData model
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(.success(weatherData))
                } catch {
                    // Handle decoding errors
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    // MARK: - Image Download
    
    func downloadImage(for iconId: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Prepare the URL for image download
        let urlString = "https://openweathermap.org/img/wn/\(iconId)@2x.png"
        
        // Create a URL from the constructed URL string
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Perform a URLSession data task to download the image
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle network errors
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Provide the downloaded image
                completion(.success(image))
            } else {
                // Handle image download failure
                completion(.failure(NetworkError.imageDownloadFailed))
            }
        }.resume()
    }
}

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case imageDownloadFailed
}
