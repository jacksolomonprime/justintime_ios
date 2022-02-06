//
//  HomeView.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI

struct HomeView: View {
    @State private var phoneNumber: String = ""
    @FocusState private var keyboardOpen: Bool
    @StateObject private var locationModel = LocationSearchViewModel()
    @StateObject var userLocation = UserLocation.shared
    @ObservedObject var currentView: CurrentView
    @State var showingDetail = false
    @State var hasLocation = false
    
    let storageChangedNotif = NotificationCenter.default.publisher(for: NSNotification.Name("update"))

    var body: some View {
        ZStack{
            MapView(userLocation: userLocation)
            
            VStack{
                HStack{
                    Spacer()
                        .frame(width: 25)
                    TextField("Enter destination", text: $locationModel.searchTerm)
                        .frame(height: 60)
                        .focused($keyboardOpen)
                }.background(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal)
                    .padding(.top, 50)
                    .cornerRadius(20)
                    .shadow(color: .white, radius: 3)
                
                List(locationModel.results) { mapItem in
                    VStack(alignment: .leading) {
                        Text(mapItem.title)
                        Text(mapItem.subtitle)
                            .foregroundColor(.secondary)
                    }.frame(height: 50)
                        .onTapGesture {
                            //Update selection
                            UserDefaults.saveLocations(originLat: userLocation.region.center.latitude, originLong: userLocation.region.center.longitude, destinationLat: mapItem.latitude, destinationLong: mapItem.longitude)
                            let destinationToSave = Destination(friendsPhones: [], secondsBeforeCall: 300, title: mapItem.title)
                            destinationToSave.saveDestination()
                            //Clear the view
                            locationModel.results = [LocationSearchResult]()
                            keyboardOpen = false
                        }
                }.listStyle(.plain)
                    .padding(.horizontal)
                
                Spacer()
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 180)
                        .opacity(hasLocation == false ? 0 : 1)
                    if Destination.getSavedDestination() != nil {
                        HStack{
                            VStack(alignment: .leading){
                                Text("We'll call you when you're near:")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 2)
                                Text("📍 \(Destination.getSavedDestination()!.title)")
                                    .font(.system(size: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.leading)
                            
                            Button("Edit") {
                                showingDetail.toggle()
                            }
                            .frame(width: 80, height: 45)
                            .background(Color.highlight)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .sheet(isPresented: $showingDetail) {
                                DestinationDetailView(currentView: currentView, friendsPhones: Destination.getSavedDestination()!.friendsPhones, showingSelf: $showingDetail)
                            }
                        }.padding()
                    }
                }
            }
        }.edgesIgnoringSafeArea([.vertical])
            .onReceive(storageChangedNotif) { _ in
                hasLocation = Destination.getSavedDestination() != nil
            }.onAppear {
                hasLocation = Destination.getSavedDestination() != nil
            }
    }
}
