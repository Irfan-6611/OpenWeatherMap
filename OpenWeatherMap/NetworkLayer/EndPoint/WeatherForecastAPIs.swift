//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//
import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}


public enum WeatherForecastAPIs {
    //TODO: fecth weather forecast api calls
    case fetchWeatherForecast(_ params: Parameters)

}

extension WeatherForecastAPIs: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.openweathermap.org/data/"
            
        case .qa: return "https://api.openweathermap.org/data/"
            
        case .staging: return "https://api.openweathermap.org/data/"
            
        }
        
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var version: String {
        return "data/2.5/"
    }
    
    var token: String {
        return   ""
    }
    
    var path: String {
        
        switch self {
        case .fetchWeatherForecast:
            return "forecast"
      
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case  .fetchWeatherForecast:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchWeatherForecast(let params):
            return .requestParametersAndHeaders(bodyParameters: nil,
                                                bodyEncoding: .urlEncoding,
                                                urlParameters: params, additionHeaders: ["Content-Type":"application/json"])
        }
        
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
}
