//
//  UserDefaults+Extension.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import CoreLocation

extension UserDefaults {
    static let defaults = UserDefaults.standard
    
    //Keys
    static let LAST_LOCATION: String = "last_location"
    static let PHONE_NUMBER: String = "phone_number"
    static let DESTINATION_LONG: String = "destination_long"
    static let DESTINATION_LAT: String = "destination_lat"
    static let ORIGIN_LONG: String = "origin_long"
    static let ORIGIN_LAT: String = "origin_lat"
    static let DESTINATION_DATA: String = "destination_data"
    static let RECORDED_SPEEDS: String = "recorded_speeds"
    static let REFRESH_INTERVAL: String = "refresh_interval"

    static func saveLastLocation(location: CLLocation) {
        if let encodedLocation = try? NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false) {
            defaults.set(encodedLocation, forKey: self.LAST_LOCATION)
        }
    }
    
    static func getLastLocation() -> CLLocation? {
        if let loadedLocation = defaults.data(forKey: self.LAST_LOCATION),
           let decodedLocation = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadedLocation) as? CLLocation {
            return decodedLocation
        }
        return nil
    }
    
    static func savePhoneNumber(number: String) {
        defaults.set(number, forKey: PHONE_NUMBER)
    }
    
    static func getPhoneNumber() -> String? {
        defaults.string(forKey: PHONE_NUMBER)
    }
    
    static func saveLocations(originLat: CLLocationDegrees?, originLong: CLLocationDegrees?,
                                        destinationLat: CLLocationDegrees?, destinationLong: CLLocationDegrees?) {
        defaults.set(originLat, forKey: ORIGIN_LAT)
        defaults.set(originLong, forKey: ORIGIN_LONG)
        defaults.set(destinationLat, forKey: DESTINATION_LAT)
        defaults.set(destinationLong, forKey: DESTINATION_LONG)
    }
    
    static func getDestination() -> (CLLocationDegrees?, CLLocationDegrees?) {
        return (defaults.object(forKey: DESTINATION_LAT) as? CLLocationDegrees, defaults.object(forKey: DESTINATION_LONG) as? CLLocationDegrees)
    }
    
    static func getOrigin() -> (CLLocationDegrees?, CLLocationDegrees?) {
        return (defaults.object(forKey: ORIGIN_LAT) as? CLLocationDegrees, defaults.object(forKey: ORIGIN_LONG) as? CLLocationDegrees)
    }
    
    static func addSpeedToQueue(speed: Float) {
        var speedArray = defaults.array(forKey: RECORDED_SPEEDS)
        if speedArray != nil {
            speedArray!.insert(speed, at: 0)
            if speedArray!.count > 100 {
                speedArray!.removeLast()
            }
        }else {
            speedArray = [speed]
        }
        defaults.set(speedArray, forKey: UserDefaults.RECORDED_SPEEDS)
    }
    
    static func getAverageSpeed() -> Float {
        let speedArray = defaults.array(forKey: RECORDED_SPEEDS)
        if speedArray != nil {
            var total: Float = 0.0
            
            for speed in speedArray! {
                total = total + (speed as! Float)
            }
            
            total = total / Float(speedArray!.count)
            return total
        } else {
            return 0
        }
    }
    
    static func setRefreshInterval(interval: Int) {
        defaults.set(interval, forKey: REFRESH_INTERVAL)
    }
    
    static func getRefreshInterval() -> Int {
        if defaults.object(forKey: REFRESH_INTERVAL) != nil {
            return defaults.integer(forKey: REFRESH_INTERVAL)
        } else {
            return 30
        }
    }
}
