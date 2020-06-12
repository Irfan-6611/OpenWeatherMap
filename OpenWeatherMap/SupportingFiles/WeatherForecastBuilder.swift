//
//  WeatherForecastBuilder.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces

class WeatherForecastBuilder {

    class func buildModule(arroundView view:WeatherForecastViewProtocol) {
        
        //MARK: Initialise components.
        let presenter = WeatherForecastPresenter()
        let interactor = WeatherForecastInteractor(withApiWorker: WeatherForecastWorker())
        let router = WeatherForecastRouter()
        
        //MARK: link VIP components.
        view.presenter = presenter
        view.interactor = interactor
        view.router = router
        
        presenter.weatherForecastView = view
        interactor.presenter = presenter
        
        GMSServices.provideAPIKey("AIzaSyCIUBp0sJSiMRCgQOJCT4pYl5rr_GSfybk")

    }
}
