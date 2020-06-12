//
//  WeatherForecastViewController.swift
//  OpenWeatherMap
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

/// Weather Forecast View Protocol
protocol WeatherForecastViewProtocol: class {
    var presenter: WeatherForecastPresenter? { get set }
    var interactor: WeatherForecastInteractor? { get set }
    var router: WeatherForecastRouter? { get set }
    
    // Update UI
    func set(viewModel: WeatherForecastViewModel)
}

class WeatherForecastViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempratureLable: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!

    var presenter: WeatherForecastPresenter?
    var interactor: WeatherForecastInteractor?
    var router: WeatherForecastRouter?
    
    var googleMapView: GMSMapView?
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor?.fetchWeatherForecast()
        configureGoogleMap()
        addBottomSheetView()

    }
    
    //MARK:- custom methods
    fileprivate  func configureGoogleMap(){
        googleMapView = GMSMapView.init(frame: self.view.frame)
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                googleMapView?.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        guard let _ = googleMapView else { return }
        self.googleMapContainerView.addSubview(googleMapView!)
        googleMapView!.isMyLocationEnabled = true
        self.locationManager.delegate = self
    }
    
    fileprivate func addBottomSheetView(scrollable: Bool? = true) {
        let bottomSheetVC =  BottomSheetViewController()
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    fileprivate func delay(seconds: Double, closure: @escaping () -> ()) {
         DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
             closure()
         }
     }
    
    fileprivate func moveTo(location: CLLocationCoordinate2D ,afterDelay: Double, slowAnimationTime: Int, zoom to:Float, delayTime: Double,  animationTime: Int){
        
        delay(seconds: afterDelay) { [weak self] in
            
            guard let self = self else { return }
            
            CATransaction.begin()
            CATransaction.setValue(slowAnimationTime, forKey: kCATransactionAnimationDuration)
            self.googleMapView?.animate(toLocation: location)
            CATransaction.commit()
            
            self.delay(seconds: delayTime, closure: {
                CATransaction.begin()
                CATransaction.setValue(animationTime, forKey: kCATransactionAnimationDuration)
                self.googleMapView?.animate(with: GMSCameraUpdate.zoom(to: to))
                CATransaction.commit()
            })
        
        }
    }
    
}

// MARK: - Location Manager Delegate Methods

extension WeatherForecastViewController: CLLocationManagerDelegate {
    
    func isLocationAccessEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
          switch CLLocationManager.authorizationStatus() {
             case .notDetermined, .restricted, .denied:
                print("No access")
             return false
            
             case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
             return true
            
          @unknown default:
             return false

        }
       } else {
            print("Location services not enabled")
            return false
       }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            self.moveTo(location: location.coordinate,
                        afterDelay: 0.1,
                        slowAnimationTime: 0,
                        zoom: 11,
                        delayTime: 0.5,
                        animationTime: 3)
            self.locationManager.stopUpdatingLocation()
        }
        
    }

    
    // Handle authorization for the location manager.
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       switch status {
       case .restricted:
         print("Location access was restricted.")
       case .denied:
         print("User denied access to location.")
         // Display the map using the default location.
       case .notDetermined:
         print("Location status not determined.")
       case .authorizedAlways: fallthrough
       case .authorizedWhenInUse:
         print("Location status is OK.")
       @unknown default:
        fatalError()
        }
     }

     // Handle location manager errors.
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       locationManager.stopUpdatingLocation()
       print("Error: \(error)")
     }
}

extension WeatherForecastViewController: WeatherForecastViewProtocol{
    func set(viewModel: WeatherForecastViewModel) {
        self.weatherImageView.image = UIImage(named: viewModel.iconName)
        self.weatherDescription.text = viewModel.weatherDescription
        self.tempratureLable.text = viewModel.tempMax
    }
    
}
