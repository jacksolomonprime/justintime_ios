//
//  CurrentView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import Foundation

class CurrentView: ObservableObject {
    @Published var showLogin: Bool = UserDefaults.getPhoneNumber() == nil
}
