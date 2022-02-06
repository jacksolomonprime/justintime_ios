//
//  Destination.swift
//  Concierge
//
//  Created by Jack A Solomon on 06/02/2022.
//

import Foundation

class Destination: ObservableObject, Codable {
    var friendsPhones: [String]
    var secondsBeforeCall: Int
    var title: String

    init(friendsPhones: [String] = [String](), secondsBeforeCall: Int = 300, title: String = "error") {
        self.friendsPhones = friendsPhones
        self.secondsBeforeCall = secondsBeforeCall
        self.title = title
    }
    
    public func saveDestination(){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: UserDefaults.DESTINATION_DATA)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        } catch {
            print("Error decoding (\(error))")
        }
    }
    
    static func getSavedDestination() -> Destination? {
        if let data = UserDefaults.standard.data(forKey: UserDefaults.DESTINATION_DATA) {
            do {
                let decoder = JSONDecoder()
                let destination = try decoder.decode(Destination.self, from: data)
                return destination
            } catch {
                print("Error decoding (\(error))")
                return nil
            }
        }
        return nil
    }
}
