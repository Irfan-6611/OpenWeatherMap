//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation
import UIKit


enum NetworkErrors: String,Error{
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "An error occurred while decoding data"
    case wentWrong = "something went wrong please try again."

}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production

    let router = Router<WeatherForecastAPIs>()
    
//    lazy var encoder: JSONEncoder = {
//        let encoder = JSONEncoder()
//        return encoder
//    }()
//
//    lazy var decoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        return decoder
//    }()

     func fetchWeatherForecast( by cityNames: Parameters, completion: @escaping (Result<WeatherForecastModle, NetworkErrors>)-> Void){
        router.request(.fetchWeatherForecast(cityNames)) { data, response, error in

            if error != nil {
                completion(.failure(.failed))
                return
            }


            guard let data = data else {
                completion(.failure(.wentWrong))
                return
            }

            do {
                let flightData = try JSONDecoder().decode(WeatherForecastModle.self, from: data)

                completion(.success(flightData))

            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                //return nil
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                // return nil
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                //return nil
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                // return nil
            } catch {
                print("error: ", error)
                //return nil
            }
        }
    }

    


}
