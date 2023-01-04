//
//  HomeViewModel.swift
//
//
import Foundation
class HomeViewModel {
    var data : [String] = []
    
    func makeUrl(with query: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.worldweatheronline.com"
        components.path = "/premium/v1/search.ashx"
        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "num_of_results", value: "10"),
            .init(name: "format", value: "json"),
            .init(name: "key", value: "ba871e68abf34aa09f863523230401")
        ]
        return components.url
    }
    
    func fetchData(query: String, success: @escaping (Search) -> Void, failure: @escaping (Error)-> Void) {
        guard let url = makeUrl(with: query) else { return }
        let urlRequest = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) {[weak self] (data, response ,error) in
            if let error = error {
                failure(error)
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Search.self, from: data)
                
                self?.data.removeAll()
                self?.dataSearchResults(searchObj: jsonData)
                
                DispatchQueue.main.async {
                    success(jsonData)
                    
                    
                }
            } catch let error {
                failure(error)
            }
        }
        dataTask.resume()
        
    }
     
    func dataSearchResults(searchObj: Search) {
        for result in searchObj.data.result {
            var string = ""
            if let areaName = result.areaName.first?.value, !areaName.isEmpty {
                string += areaName
            }
            if let country = result.country.first?.value, !country.isEmpty {
                string += ", "  + country
            }
            if let region = result.region.first?.value, !region.isEmpty {
                string += ", "  + region
            }
            if !string.isEmpty {
                self.data.append(string)
            }
        }
    }
}
