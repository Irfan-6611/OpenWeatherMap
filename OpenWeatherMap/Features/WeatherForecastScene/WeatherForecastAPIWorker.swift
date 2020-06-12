//
//  WeatherForecastAPIWorker.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation

enum OpenWeatherMapError: Error {
  case invalidResponse
  case noData
  case failedRequest
  case invalidData
}

///Weather Forecast API Worker Protocol
protocol WeatherForecastWorkerProtocol {
    func fetchWeatherForecast(by cityName:String, success:@escaping (WeatherForecastModle) -> Void, failiur:@escaping (OpenWeatherMapError) -> Void)
}

class WeatherForecastWorker: WeatherForecastWorkerProtocol {
    
    private let apiKey = "a8da1505ef02159ce58390488443214c"
    private let host = "https://api.openweathermap.org"
    private let path = "/data/2.5/weather"
    private let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd:HH"
      return formatter
    }()

    
    func fetchWeatherForecast(by cityName:String, success:@escaping (WeatherForecastModle) -> Void, failiur:@escaping (OpenWeatherMapError) -> Void) {
        
        let session = URLSession(configuration: .default)
        var datatask : URLSessionDataTask?
        var items = [URLQueryItem]()
        var myURL = URLComponents(string: host + path)
        let param = ["appid":apiKey,"q": cityName]
        for (key,value) in param {
            items.append(URLQueryItem(name: key, value: value))
        }
        myURL?.queryItems = items
        let request =  URLRequest(url: (myURL?.url)!)
        print(request)

        datatask = session.dataTask(with: request, completionHandler: {data, response, error in
            if error == nil {
                
                guard let data = data else {
                    failiur(.invalidData)
                    return
                }
                do {
                    let weather = try JSONDecoder().decode(WeatherForecastModle.self, from: data)
                    DispatchQueue.main.async {
                        success(weather)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        failiur(.invalidResponse)
                    }
                }
                
            }
        })
        datatask?.resume()
        
        
        
        /// Separate Netwrork layer
//        let param = ["appid":"a8da1505ef02159ce58390488443214c","q": cityName] as Parameters
//
//        NetworkManager().fetchWeatherForecast(by: param) { (result) in
//            switch result{
//            case .success(let weatherModel):
//                DispatchQueue.main.async {
//                    callBack(weatherModel)
//                }
//
//            case .failure(let err):
//                print(err.rawValue)
//            }
//        }

        
    }
    
}
