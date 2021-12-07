//
//  FavoritesView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 25/11/21.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var scoresVM:ScoresVM
    let columns:[GridItem] = .init(repeating: .init(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            ScrollView {
                if scoresVM.featuredScores.count == 0 {
                    Text("Theres no featured scores")
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(scoresVM.featuredScores) { score in
                             FavouriteRowView(score: score)
                                .contextMenu {
                                    Button {
                                        withAnimation() {
                                            scoresVM.toggleFeatured(score: score)
                                        }
                                    } label: {
                                        Label("Un-featured", systemImage: "star")
                                    }

                                }
                        }
                    }
                    .padding()
                }
                
            }
            .navigationTitle("Featured Scores")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(ScoresVM())
    }
}
