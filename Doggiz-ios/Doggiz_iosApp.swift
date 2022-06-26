//
//  Doggiz_iosApp.swift
//  Doggiz-ios
//
//  Created by Or Zino on 13/06/2022.
//

import SwiftUI
import Firebase

@main
struct Doggiz_iosApp: App {
    @StateObject var dataManager = DataManager()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
