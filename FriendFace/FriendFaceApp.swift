//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Fernando Callejas on 15/08/24.
//

import SwiftData
import SwiftUI

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
