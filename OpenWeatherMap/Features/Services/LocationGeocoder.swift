//
//  WeatherForecastViewController.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 12/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation
import CoreLocation

class LocationGeocoder {
  private lazy var geocoder = CLGeocoder()
  
  ///Convert a place name to a location
  func geocode(addressString: String, callback: @escaping ([Location]) -> ()) {
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
      var locations: [Location] = []
      if let error = error {
        print("Geocoding error: (\(error))")
      } else {
        if let placemarks = placemarks {
          locations = placemarks.compactMap { (placemark) -> Location? in
            guard
              let name = placemark.locality,
              let location = placemark.location
              else {
                return nil
            }
            let region = placemark.administrativeArea ?? ""
            let fullName = "\(name), \(region)" 
            return Location(
              name: fullName,
              latitude: location.coordinate.latitude,
              longitude: location.coordinate.longitude)
          }
        }
      }
      callback(locations)
    }
  }
}
