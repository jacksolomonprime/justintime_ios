//
//  ContentView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI
import CountryPicker

struct LoginView: View {
    @State var country: Country? = Country(phoneCode: "44", isoCode: "GB")
    @State var showCountryPicker = false
    @State var phoneNumber: String = ""
    @FocusState var keyboardOpen: Bool
    @ObservedObject var currentView: CurrentView
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading){
                Text("Just In Time")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .padding(20)
                
                Text("Enter your number to get notified when you're close to home 🏡")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.horizontal, 20)
            }
                        
            PhoneEntry(country: $country, showCountryPicker: $showCountryPicker, phoneNumber: $phoneNumber, keyboardOpen: _keyboardOpen, currentView: currentView, onSave: { number in
                UserDefaults.savePhoneNumber(number: number)
                currentView.showLogin = false
            })
            
            Spacer()
            
            Image("train")
                .resizable()
                .scaledToFit()
                .offset(y: 40)
        }.edgesIgnoringSafeArea([.bottom])
            .background(Color.navy)
    }
}
