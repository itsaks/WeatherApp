//
//  WebserviceManager.swift
//  WeatherApp
//
//  Created by Arvind Singh on 23/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceManager {
    
    let baseUrl:String
    
    var data:CityWeatherInfo?
    
    init(baseURL:String) {
        self.baseUrl = baseURL
    }
    
    
    // Call the REST API and decode the success response
    func GetDataForCity(cityID:Int, completion:@escaping (_ success: CityWeatherInfo?, _ error: Error?) -> Void){
        
        Alamofire.request(baseUrl + String(cityID) + "&units=metric&APPID=" + Constants.OpenWeather.ApiKey)
            
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                   // print("--\(response)")
                    //use your json result
                    let result = response.data
                    do{
                        self.data = try JSONDecoder().decode(CityWeatherInfo.self, from: result!)
                        completion(self.data!,nil)
                        
                    }catch {
                        print("error...")
                    }
                    
                    
                    
                case .failure (let error):
                    
                    print("\n\nAuth request failed error:\n \(error)")
                    completion(nil, error)
                    
                }//switch end
        }
        
    }
    
    
}
