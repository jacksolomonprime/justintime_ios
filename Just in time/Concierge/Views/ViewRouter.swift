//
//  ViewRouter.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI

struct ViewRouter: View {
    @ObservedObject var currentView = CurrentView()
    
    var body: some View {
        Group {
            if currentView.showLogin {
                LoginView(currentView: currentView)
            } else {
                HomeView(currentView: currentView)
            }
        }
    }
}
