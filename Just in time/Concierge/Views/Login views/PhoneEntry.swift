//
//  PhoneEntry.swift
//  Concierge
//
//  Created by Jack A Solomon on 06/02/2022.
//

import SwiftUI
import CountryPicker

struct PhoneEntry: View {
    @Binding var country: Country?
    @Binding var showCountryPicker: Bool
    @Binding var phoneNumber: String
    @FocusState var keyboardOpen: Bool
    @ObservedObject var currentView: CurrentView
    var onSave: (String) -> Void

    var body: some View {
        HStack{
            HStack(alignment: .center){
                Button {
                    showCountryPicker = true
                } label: {
                    Text("\(country!.isoCode.getFlag())")
                        .frame(width: 60, height: 60)
                }.sheet(isPresented: $showCountryPicker) {
                    CountryPicker(country: $country)
                }
                
                TextField("+\(country!.phoneCode)", text: $phoneNumber)
                    .frame(height: 60)
                    .focused($keyboardOpen)
                
                Button {
                    let characterSet = CharacterSet(charactersIn: "+()-0123456789")
                    let result = phoneNumber.trimmingCharacters(in: characterSet.inverted)
                    self.onSave(result)
                } label: {
                    ZStack{
                        Rectangle()
                            .foregroundColor(.highlight)
                        
                        Text("➠")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                        
                    }.frame(width: 55, height: 60)
                }
            }.background(Color.light_gray)
                .border(Color.highlight, width: keyboardOpen ? 4 : 0)
                .cornerRadius(7.5)
                .padding(20)
        }
    }
}
