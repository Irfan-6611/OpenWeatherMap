//
//  WeatherForecastInteractor.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation

protocol WeatherForecastInteractorProtocol {
    // Fetch current weather temprature from Data Layer
    func fetchWeatherForecast()
}

class WeatherForecastInteractor {
    private let worker: WeatherForecastWorkerProtocol?
    
    var presenter: WeatherForecastPresenterProtocol?
    
    required init(withApiWorker apiWorker:WeatherForecastWorkerProtocol) {
        self.worker = apiWorker
    }
}

extension WeatherForecastInteractor: WeatherForecastInteractorProtocol{
    func fetchWeatherForecast() {
        worker?.fetchWeatherForecast(by: "Dubai", success: { (weatherForecast) in
            self.presenter?.interactor(self, didFetch: weatherForecast)
        }, failiur: { (error) in
            self.presenter?.interactor(self, didFailWith: error)
        })
    }

}
