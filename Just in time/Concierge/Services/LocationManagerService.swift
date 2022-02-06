//
//  LocationManagerService.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import CoreLocation
import Combine

class LocationManagerService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared: LocationManagerService = LocationManagerService()
    
    var locationManager: CLLocationManager = CLLocationManager()
        
    //MARK: Initialization
    //Request authorization and start tracking
    override init() {
        super.init()
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: Monitor updates
    public func startMonitoringChanges() {
        //Check that the device supports monitoring
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() { return }
        
        //Start monitoring location
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopMonitoringChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    public func cancelTrip() {
        self.stopMonitoringChanges()
        UserDefaults.standard.set(nil, forKey: UserDefaults.DESTINATION_DATA)
        UserDefaults.saveLocations(originLat: nil, originLong: nil, destinationLat: nil, destinationLong: nil)
        UserDefaults.setRefreshInterval(interval: 30) //reset to default
        //Send update to home view
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        //We should make an API call
        if UserDefaults.getDestination().0 != nil && UserDefaults.getOrigin().0 != nil {
            //Check that the data is more than a minute old
            let previousLocation = UserDefaults.getLastLocation()
            let currentLocation = locations.last!
            UserDefaults.addSpeedToQueue(speed: Float(locations.last!.speed))
                        
            if previousLocation != nil {
                let secondsDiff = currentLocation.timestamp.secondsSince(date: previousLocation!.timestamp)
                if Int(round(secondsDiff)) < UserDefaults.getRefreshInterval() { return }
            }
            
            UserDefaults.saveLastLocation(location: currentLocation)
            
            print("MAKING API CALL")
            APIManagerService.shared.makeAPICall(originLat: currentLocation.coordinate.latitude, originLong: currentLocation.coordinate.longitude, destinationLat: UserDefaults.getDestination().0!, destinationLong: UserDefaults.getDestination().1!, speed: UserDefaults.getAverageSpeed(), friendNumbers: Destination.getSavedDestination()!.friendsPhones)
        }
    }
    
    //MARK: Error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            //Location updates are not authorized.
            self.stopMonitoringChanges()
            print("Error updating locations. Monitoring has been disabled.")
            return
        }
    }
}
