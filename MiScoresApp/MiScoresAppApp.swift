//
//  MiScoresAppApp.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

@main
struct MiScoresAppApp: App {
    @StateObject var scoresVM = ScoresVM()
    var body: some Scene {
        WindowGroup {
            TabScreenView()
                .environmentObject(scoresVM)
        }
    }
}
