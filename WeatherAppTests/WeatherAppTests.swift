//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Arvind Singh on 22/03/18.
//  Copyright © 2018 Arvind Singh. All rights reserved.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    func testWebServiceManager(){
        
        let webServicemanager = WebServiceManager(baseURL: Constants.OpenWeather.BaseURL)
        let exp = expectation(description: "WebServiceManager Successfull")
        webServicemanager.GetDataForCity(cityID:2147714, completion: {
            response,error in
            
            print("\(String(describing: response))")
            XCTAssertNil(error, "Error \(error!.localizedDescription)")
            XCTAssert(response?.name == "Sydney", "Service Failed")
            exp.fulfill()
            
        })
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testUnixDateConverter(){
        
        let dstring: String = Utility.unixStyleToNormalDateConvert(unixDate: 1521714185, formatType: "d MMM, HH:mm a")
        
        print("dstring: \(dstring)")
        XCTAssert(dstring == "22 Mar, 21:23 PM", "Failed")
        
        
    }

    
}
