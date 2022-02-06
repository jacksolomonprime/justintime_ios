//
//  LocationSearchViewModel.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation
import MapKit
import Combine

final class LocationSearchViewModel: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var searchTerm = "" { didSet { service.searchCities(searchText: searchTerm) } }
    @Published var results = [LocationSearchResult]()

    var service: LocationSearchService
    
    init() {
        //Default coordinates
        service = LocationSearchService(center: UserLocation.shared.region.center)
        cancellable = service.locationSearchPublisher.sink { mapItems in
            self.results = mapItems.map({ LocationSearchResult(mapItem: $0) })
        }
    }
}
