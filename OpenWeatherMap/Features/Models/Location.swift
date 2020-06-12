//
//  WeatherForecastViewController.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 12/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
  let name: String
  let latitude: Double
  let longitude: Double
  
  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}

extension Location: Equatable {
  static func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.name == rhs.name &&
      lhs.latitude == rhs.latitude &&
      lhs.longitude == rhs.longitude
  }
}
