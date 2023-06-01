//
//  WeatherData.swift
//  Coding-Challenge-Weather
//
//  Created by Andres S. Hernandez G. on 5/31/23.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds

    struct Main: Codable {
        let temperature: Double
        let realFeel: Double
        let humidity: Int

        private enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case realFeel = "feels_like"
            case humidity
        }
    }

    struct Weather: Codable {
        let weatherDescription: String
        let weatherIcon: String

        private enum CodingKeys: String, CodingKey {
            case weatherDescription = "description"
            case weatherIcon = "icon"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Clouds: Codable {
        let all: Int
    }
}
