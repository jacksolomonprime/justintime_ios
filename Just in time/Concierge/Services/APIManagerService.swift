//
//  APIManagerService.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import MapKit

class APIManagerService {
    static let shared: APIManagerService = APIManagerService()
    
    public func makeAPICall(originLat: CLLocationDegrees, originLong: CLLocationDegrees,
                            destinationLat: CLLocationDegrees, destinationLong: CLLocationDegrees,
                            timeBeforeAlarm: Int = 300, speed: Float,
                            friendNumbers: [String]) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://ichack-22.herokuapp.com/call?origin=\(originLat),\(originLong)&destination=\(destinationLat),\(destinationLong)&timeBeforeAlarm=\(timeBeforeAlarm)&speed=\(speed)&phoneNumber=\(UserDefaults.getPhoneNumber() ?? "+0")&smsNumbers=\((friendNumbers.map{$0}).joined(separator: ","))")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 60.0)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "ERROR")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("HTTP status code: \(String(describing: httpResponse?.statusCode))")
                let responseData = String(data: data!, encoding: String.Encoding.utf8)
                print("RESPONSE DATA IS: \(String(describing: responseData))")
                if responseData != nil && Float(responseData!) != 0 {
                    let interval = Float(responseData!)
                    let intervalInt = Int(interval!)
                    UserDefaults.setRefreshInterval(interval: intervalInt)
                } else {
                    //LocationManagerService.shared.cancelTrip()
                }
            }
        })

        dataTask.resume()
    }
}
