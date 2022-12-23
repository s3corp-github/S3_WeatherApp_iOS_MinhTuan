//
//  Model.swift
//  WeatherApp(Resit)
//
//  Created by tuan.nguyen on 4/6/22.
//

import Foundation

struct Value: Codable {
    let value: String
}

struct SearchData: Codable {
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case data = "search_api"
    }
}

// MARK: - SearchData.Data
extension SearchData {
    struct Data: Codable {
        let result: [Result]
    }
}

// MARK: - SearchData.Result
extension SearchData {
    struct Result: Codable {
        let areaName: [Value]
        let country: [Value]
        let region: [Value]
    }
}



    



