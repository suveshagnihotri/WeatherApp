//
//  WeatherGetter.swift
//  WeatherApp
//
//  Created by Suvesh Agnihotri on 09/04/2560 BE.
//  Copyright © 2560 BE Suvesh Agnihotri. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}

class WheatherGetter{
    //weather api Url
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    //api key
    private let openWeatherMapAPIKey="0aa878ec028b45704610571611738e28";
    private var delegate: WeatherGetterDelegate

    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeather(city:String){
    // This is a pretty simple networking task, so the shared session will do.
    let session = NSURLSession.sharedSession()
    
    let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
    // The data task retrieves the data.
    let dataTask = session.dataTaskWithURL(weatherRequestURL) {
    (data: NSData?, response: NSURLResponse?, error: NSError?) in
    if let error = error {
    // Case 1: Error
    // We got some kind of error while trying to get data from the server.
    print("Error:\n\(error)")
    self.delegate.didNotGetWeather(error)

    }
    else {
    // Case 2: Success
    // We got a response from the server!
    print("Data:\n\(data!)")
    let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
    print("output data:\n\(dataString!)")
        do{
            // Try to convert that data into a Swift dictionary
            let weatherData = try NSJSONSerialization.JSONObjectWithData(
                data!,
                options: .MutableContainers) as! [String: AnyObject]
            
            // If we made it to this point, we've successfully converted the
            // JSON-formatted weather data into a Swift dictionary.
            // Let's now used that dictionary to initialize a Weather struct.
            let weather = Weather(weatherData: weatherData)
            
            // Now that we have the Weather struct, let's notify the view controller,
            // which will use it to display the weather to the user.
            self.delegate.didGetWeather(weather)
            
        }catch let jsonError as NSError {
            // An error occurred while trying to convert the data into a Swift dictionary.
            print("JSON error description: \(jsonError.description)")
            self.delegate.didNotGetWeather(jsonError)
        }
    }
}
    
    // The data task is set up...launch it!
    dataTask.resume()
    }
}

