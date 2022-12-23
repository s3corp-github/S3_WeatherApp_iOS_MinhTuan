//
//  Weather.swift
//  WeatherApp(Resit)
//
//  Created by tuan.nguyen on 4/6/22.
//

import Foundation

 struct WeatherData: Decodable {
    let data: Data
}

extension WeatherData {
    struct Data: Decodable {
        let currentCondition: [CurrentCondition]

        enum CodingKeys: String, CodingKey {
            case currentCondition = "current_condition"
        }
    }
}

extension WeatherData {
    struct CurrentCondition: Decodable {
        let weatherIconUrl: [Value]
        let humidity: String
        let description: [Value]
        let temperature: String

        enum CodingKeys: String, CodingKey {
            case weatherIconUrl
            case humidity
            case description = "weatherDesc"
            case temperature = "temp_C"
        }
    }
}
