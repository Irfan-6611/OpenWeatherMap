//
//  WeatherForecastTableViewCell.swift
//  Exponent
//
//  Created by Irfan Ahmed on 11/03/2020.
//  Copyright © 2020 Exponent. All rights reserved.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherTitleLable: UILabel!
    @IBOutlet weak var tempratureLable: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    @IBOutlet weak var pressureLable: UILabel!
    @IBOutlet weak var windSpeedLable: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var degreeView: UIView!

    
    static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var weather: WeatherForecastModle? {
        didSet{
            guard let weather = weather else { return }
            weatherTitleLable.text = weather.weather[0].main
            tempratureLable.text = "\(((weather.main.temp - 32) / 1.8).rounded())"
            humidityLable.text = "\(weather.main.humidity)"
            pressureLable.text = "\(weather.main.pressure)"
            windSpeedLable.text = "\(weather.wind.speed)"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        degreeView.layer.cornerRadius = degreeView.bounds.width/2
        degreeView.layer.borderColor = UIColor.black.cgColor
        degreeView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
