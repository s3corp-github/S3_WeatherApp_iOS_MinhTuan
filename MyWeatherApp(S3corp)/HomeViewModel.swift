//
//  HomeViewModel.swift
//  WeatherApp(Resit)
//
//  Created by tuan.nguyen on 4/5/22.
//

import Foundation

class HomeViewModel {
    
    func fetchData(query: String, success: @escaping (SearchData) -> Void,failure: @escaping (Error)-> Void) {
        func makeUrl(with query: String) -> URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.worldweatheronline.com"
            components.path = "/premium/v1/search.ashx"
            components.queryItems = [
                .init(name: "q", value: query),
                .init(name: "num_of_results", value: "10"),
                .init(name: "format", value: "json"),
                .init(name: "key", value: "0c3821cc308b46fb8a594405221403")
            ]
            return components.url
        }
        
        guard let url = makeUrl(with: query) else { return }
        let urlRequest = URLRequest(url: url)
            // Create URL Session - work on the backgroundi
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response ,error) in
                
                if let error = error {
                    failure(error)
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    // Handle Empty Response
                    print("Empty Response")
                    return
                }
                print("Response status code: \(response.statusCode)")
                
                guard let data = data else {
                    // Handle Empty Data
                    print("Empty Data")
                    return
                }
                
                do {
                    // Parse the data
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(SearchData.self, from: data)
                    
                    // Back to the main thread
                    DispatchQueue.main.async {
                        success(jsonData)
                    }
                } catch let error {
                    failure(error)
                }
                
            }
        dataTask.resume()
    }
}

