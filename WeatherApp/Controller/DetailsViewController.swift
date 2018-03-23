//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Arvind Singh on 23/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var bckCityImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var sunRiseImage: UIImageView!
    @IBOutlet weak var sunSetImage: UIImageView!
    
    @IBOutlet weak var metricLabel: UILabel!
    
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var sunSetLabel: UILabel!
    
    @IBOutlet weak var sunRiseLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var cloudinessLbl: UILabel!
    
    @IBOutlet weak var windSpeedLbl: UILabel!
    
    @IBOutlet weak var pressureLbl: UILabel!
    
    var cityDetails: CityWeatherInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let city = cityDetails {
            
            self.title = city.name
            ConfigureDetailView(city:city)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //for effects
        tempLabel.center.x -= 20
        metricLabel.center.x -= 20
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //add some effects for temp and metric label
        UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn, animations: {
            
            //self.weatherInfoLabel.center.y += 10
            self.tempLabel.center.x += 20
            self.metricLabel.center.x += 20
        }){ _ in
            self.sunRiseImage.dim()
            self.sunSetImage.dim()
            
        }
        
    }
    
    
    func  ConfigureDetailView(city:CityWeatherInfo){
        
        //setup the image according to selected city
        switch city.name {
            
        case "Sydney":
            bckCityImage.image =  UIImage(named: "sydney.jpg")
        case "Melbourne":
            bckCityImage.image =  UIImage(named: "melbourne.jpg")
        case "Brisbane":
            bckCityImage.image =  UIImage(named: "brisbane.jpg")
        default:
            bckCityImage.image =  UIImage(named: "Australia.jpg")
        }
        
        tempLabel.text = String(Int((city.main.temp.rounded()))) + "\u{00B0}"
        weatherInfoLabel.text = city.weather[0].description
        
        //set the weather image
        SetWeatherImage(city:city)
        
        //sunrise and sunset
        sunRiseLabel.text = Utility.unixStyleToNormalDateConvert(unixDate: city.sys.sunrise,formatType:"HH:mm a")
        sunSetLabel.text = Utility.unixStyleToNormalDateConvert(unixDate: city.sys.sunset,formatType:"HH:mm a")
        
        humidityLabel.text = String(city.main.humidity) + "%"
        cloudinessLbl.text = String(city.clouds.all) + "%"
        windSpeedLbl.text = String(city.wind.speed) + " m/s"
        pressureLbl.text = String(city.main.pressure) + " hPa"
    }
    
    
    func SetWeatherImage(city:CityWeatherInfo){
        
        // avoid blocking the main thread using concurrent background queues
        DispatchQueue.global(qos: .userInitiated).async { [ weak self] in
            
            let weatherURL = URL(string: "http://openweathermap.org/img/w/" + (city.weather[0].icon)+".png" )
            
            let urlContents = try? Data(contentsOf: weatherURL!)
            //put UI update on main thread.
            if let imageData = urlContents {
                DispatchQueue.main.async {
                    self?.weatherImage.image = UIImage(data: imageData)
                }
            }
            
        }
        
    }
    
    
}

