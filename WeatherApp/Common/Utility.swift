//
//  Utility.swift
//  WeatherApp
//
//  Created by Arvind Singh on 23/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class Utility{
    
    class func hasConnectivity() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    class func unixStyleToNormalDateConvert(unixDate:TimeInterval, formatType:String) -> String{
        
        let date = NSDate(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType
        return dateFormatter.string(from: date as Date)
    }
    
    
}

extension UIView{
    
    func dim(){
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.25
            
        }) { (finished) in
            
            UIView.animate(withDuration: 1, animations: {
                self.alpha = 1.0
                
            })
        }
    }
    
}



