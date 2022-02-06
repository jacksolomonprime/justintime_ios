//
//  DestinationDetailView.swift
//  Concierge
//
//  Created by Jack A Solomon on 06/02/2022.
//

import SwiftUI

struct DestinationDetailView: View {
    @State var callBeforeTime = 1
    @ObservedObject var currentView: CurrentView
    @State var showingDetail = false
    @State var friendsPhones: [String]
    @Binding var showingSelf: Bool
    
    var callBeforeTimes = ["1 min", "5 mins", "10 mins"]
    
    
    var body: some View {
        VStack{
            Text("Your trip")
                .font(.system(size: 30, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)
            
            Text("See you at \(Destination.getSavedDestination()!.title)!")
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 10)

            List {
                //YOUR NUMBER SECTION
                Section(header: Text("Call you before arrival:")) {
                    HStack{
                        Text("\(UserDefaults.getPhoneNumber() ?? "Error")")
                        Spacer()
                        Text("🙋").padding()
                    }
                }
                
                //YOUR NUMBER SECTION
                Section(header: Text("SMS your friends before arrival:")) {
                    ForEach(friendsPhones, id: \.self) { number in
                        Text("\(number)").padding()
                    }
                    Button("Add a friend") {
                        showingDetail.toggle()
                    }
                    .padding()
                    .sheet(isPresented: $showingDetail) {
                        FriendPhoneEntryView(currentView: currentView, showingView: $showingDetail, friendsPhones: $friendsPhones)
                    }
                }
                
                Section(header: Text("Notify me \(callBeforeTimes[callBeforeTime]) before arrival:")) {
                    Picker("", selection: $callBeforeTime) {
                        Text("1 min").tag(0)
                        Text("5 mins").tag(1)
                        Text("10 mins").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: callBeforeTime) { value in
                        var seconds = 0
                        if value == 0 {
                            seconds = 60
                        }else if value == 1 {
                            seconds = 300
                        }else {
                            seconds = 600
                        }
                        let destinationToSave = Destination(friendsPhones: Destination.getSavedDestination()!.friendsPhones, secondsBeforeCall: seconds, title: Destination.getSavedDestination()!.title)
                        destinationToSave.saveDestination()
                    }

                    Button("Cancel trip") {
                        LocationManagerService.shared.cancelTrip()
                        showingSelf.toggle()
                    }
                    .padding()
                    .foregroundColor(.red)
                    .sheet(isPresented: $showingDetail) {
                        FriendPhoneEntryView(currentView: currentView, showingView: $showingDetail, friendsPhones: $friendsPhones)
                    }
                }.onAppear{
                    if Destination.getSavedDestination() != nil {
                        let seconds = Destination.getSavedDestination()!.secondsBeforeCall
                        if seconds == 300 {
                            callBeforeTime = 1
                        } else if seconds == 600 {
                            callBeforeTime = 2
                        }
                    }
                }
            }
        }
    }
}


