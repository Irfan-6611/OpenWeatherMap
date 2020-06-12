//
//  WeatherForecastPresenter.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation

protocol WeatherForecastPresenterProtocol {
    /// The Interactor will inform the Presenter a successful fetch.
    func interactor(_ interactor: WeatherForecastInteractorProtocol, didFetch object: WeatherForecastModle)
    /// The Interactor will inform the Presenter a failed fetch.
    func interactor(_ interactor: WeatherForecastInteractorProtocol, didFailWith error: Error)
    
    
}

///Weather View Model
struct WeatherForecastViewModel {
    var tempMin: String
    var tempMax: String
    var weatherDescription: String
    var iconName: String
    var windSpeed: Double
}

class WeatherForecastPresenter{
    
    weak var weatherForecastView: WeatherForecastViewProtocol?
    var interactor: WeatherForecastInteractorProtocol?
    
    private let tempFormatter: NumberFormatter = {
      let tempFormatter = NumberFormatter()
      tempFormatter.numberStyle = .none
      return tempFormatter
    }()
        
}

extension WeatherForecastPresenter:WeatherForecastPresenterProtocol {
    func interactor(_ interactor: WeatherForecastInteractorProtocol, didFetch object: WeatherForecastModle) {
        let viewModel = WeatherForecastViewModel(tempMin: self.tempFormatter.string(from: object.main.tempMin as NSNumber) ?? "",
                                                 tempMax: self.tempFormatter.string(from: object.main.tempMax as NSNumber) ?? "",
                                                 weatherDescription: object.weather[0].weatherDescription,
                                                 iconName: object.weather[0].icon,
                                                 windSpeed: object.wind.speed)
        
        weatherForecastView?.set(viewModel: viewModel)
    }
    
    func interactor(_ interactor: WeatherForecastInteractorProtocol, didFailWith error: Error) {
        
    }
    
}
