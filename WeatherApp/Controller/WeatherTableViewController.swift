//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by Arvind Singh on 23/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    var cityWeatherInfoArray = [CityWeatherInfo]()
    
    //Dictionary for city name and city Id mapping
    let cityCodes:[String:Int] = ["Sydney": 2147714,"Melbourne": 2158177,"Brisbane": 2174003]
    
    //Dictionary for city id and temperature
    var cityTemp:[Int:String] = [2147714:"",2158177:"",2174003:""]
    
    
    private let webServicemanager = WebServiceManager(baseURL: Constants.OpenWeather.BaseURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch the data and load it in table
        fetchWeatherData()
        
        //hide the non used rows
        tableView.tableFooterView = UIView()
        
    }
    
    @IBAction func RefreshButtonPressed(_ sender: Any) {
        
        //clear the previous data
        cityWeatherInfoArray = []
        cityTemp = [2147714:"",2158177:"",2174003:""]
        self.tableView.reloadData()
        
        //refresh the data
        fetchWeatherData()
    }
    
    func fetchWeatherData(){
        
        //check for internet connection
        if !Utility.hasConnectivity(){
            NoConnectionAlert()
            return
        }
        
        for key in cityTemp.keys {
            
            webServicemanager.GetDataForCity(cityID:key) { [weak self]
                response,error in
                
                if(error != nil){
                    
                    let alert = UIAlertController(title: "Error getting data.", message: "There is some issue in fetching data. Please try again later.", preferredStyle: .alert)
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
                
                self?.cityWeatherInfoArray.append(response!)
                self?.cityTemp[key] = String(Int((response?.main.temp.rounded())!))
                self?.tableView.reloadData()
                
            }
            
        }
    }
    
    
    // Alert for offline connectivity
    func NoConnectionAlert(){
        
        let alert = UIAlertController(title: "No Internet Connection!", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.fetchWeatherData()
            
        }))
        self.present(alert, animated: true)
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityCodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! CityCell
        
        let keyValue:String = Array(cityCodes)[indexPath.row].key
        cell.cityLabel.text = keyValue
        
        //get the temp value from cityTemp dictionary
        let tempValue = GetTempValue(cityName:keyValue)
        
        if (tempValue != "") {
            
            cell.activityIndicator.stopAnimating()
            cell.tempLabel.text =  tempValue + "\u{00B0}"
            cell.unitLabel.isHidden = false
            cell.tempLabel.isHidden = false
            cell.lastUpdatedLbl.isHidden = false
            //update the time label via timestap from Openweather API
            let cityId:Int = Array(cityCodes)[indexPath.row].value
            let timeStamp: TimeInterval = (cityWeatherInfoArray.filter(){ $0.id == cityId}.first?.dt)!
            
            cell.lastUpdatedLbl.text = "updated: " + Utility.unixStyleToNormalDateConvert(unixDate:timeStamp, formatType: "d MMM , HH:mm a")
            
        }else{
            cell.activityIndicator.startAnimating()
            cell.unitLabel.isHidden = true
            cell.tempLabel.isHidden = true
            cell.lastUpdatedLbl.isHidden = true
        }
        
        return cell
    }
    
    
    //Get the temperature value based on the city id
    func GetTempValue(cityName:String) -> String{
        
        guard let id = cityCodes[cityName], let x = cityTemp[id] else {
            return ""
        }
        return x
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailSegue", sender: self)
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //change navigation back button name
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        //check the segueid and pass the data
        if segue.identifier == "detailSegue"{
            if let detailsVC = segue.destination as? DetailsViewController{
                
                //get the data from struct array via city id and not via name as city id is unique.
                let id:Int = Array(cityCodes)[(tableView.indexPathForSelectedRow?.row)!].value
                
                detailsVC.cityDetails = cityWeatherInfoArray.filter(){ $0.id == id}.first
                
            }
        }
        
        
        
    }
    
    
}

