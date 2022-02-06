//
//  LocationSearchService.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import Combine
import MapKit

class LocationSearchService {
    let locationSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let radius: CLLocationDistance
    
    var userLocation = UserLocation.shared
    
    init(center: CLLocationCoordinate2D,
         radius: CLLocationDistance = 10000) {
        self.radius = radius
    }
    
    public func searchCities(searchText: String) {
        request(searchText: searchText)
    }
        
    private func request(searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: userLocation.region.center,
                                            latitudinalMeters: radius,
                                            longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] (response, _) in
            guard let response = response else {
                return
            }
            self?.locationSearchPublisher.send(response.mapItems)
        }
    }
}
