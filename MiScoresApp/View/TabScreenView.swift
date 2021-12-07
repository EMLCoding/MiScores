//
//  TabScreenView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 25/11/21.
//

import SwiftUI

struct TabScreenView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Scores", systemImage: "music.note")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
    }
}

struct TabScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TabScreenView()
    }
}
