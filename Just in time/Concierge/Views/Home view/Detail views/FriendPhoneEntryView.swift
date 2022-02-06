//
//  FriendPhoneEntryView.swift
//  Concierge
//
//  Created by Jack A Solomon on 06/02/2022.
//

import SwiftUI
import CountryPicker
struct FriendPhoneEntryView: View {
    @State var country: Country? = Country(phoneCode: "44", isoCode: "GB")
    @State var showCountryPicker = false
    @State var phoneNumber: String = ""
    @FocusState var keyboardOpen: Bool
    @ObservedObject var currentView: CurrentView
    @Binding var showingView: Bool
    @Binding var friendsPhones: [String]

    var body: some View {
        VStack {
            Text("Add friend")
                .font(.system(size: 30, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.top)
            
            PhoneEntry(country: $country, showCountryPicker: $showCountryPicker, phoneNumber: $phoneNumber, keyboardOpen: _keyboardOpen, currentView: currentView, onSave: { number in
                //Save the new number
                var phoneArr = Destination.getSavedDestination()!.friendsPhones
                phoneArr.append(number)
                let destinationToSave = Destination(friendsPhones: phoneArr, secondsBeforeCall: Destination.getSavedDestination()!.secondsBeforeCall, title: Destination.getSavedDestination()!.title)
                destinationToSave.saveDestination()

                //Update model
                friendsPhones = destinationToSave.friendsPhones
                
                //Close the view
                showingView = false
            })
        }.frame(maxHeight: .infinity, alignment: .top)
            .onAppear{
                keyboardOpen = true
            }
    }
}
