//
//  LocationSearchResult.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import MapKit
import Combine

struct LocationSearchResult: Identifiable, Hashable {
    var id = UUID() //default to unique ID
    var title: String
    var subtitle: String
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees

    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
