//
//  ContentView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var scoresVM: ScoresVM
    @State var showAdd = false
    @State var showSort = false
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(scoresVM.scoresSource) { score in
                    NavigationLink(destination: ScoreDetailView(score: score)) {
                        ScoreRowView(score: score)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            scoresVM.selectedScore = score
                            showAlert.toggle()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            scoresVM.toggleFeatured(score: score)
                        } label: {
                            Label("Featured", systemImage: "star")
                        }
                        .tint(scoresVM.isFeatured(score: score) ? .red : .green)
                    }
                }
                .alert(Text("Alerta de borrado"),
                       isPresented: $showAlert) {
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }
                    Button(role: .destructive) {
                        scoresVM.deleteScore()
                    } label: {
                        Text("Delete score")
                    }
                }
            }
            .navigationTitle("Scores")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSort.toggle()
                    } label: {
                        Text("Sort")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
            }
        }
        .searchable(text: $scoresVM.search)
        .sheet(isPresented: $showAdd) { // Tambien existe .fullScreenCover
            AddScoreView(showAdd: $showAdd)
        }
        .confirmationDialog("Sort options", isPresented: $showSort) {
            Button {
                scoresVM.sortType = .ascendent
            } label: {
                Text("Ascendent")
            }
            Button {
                scoresVM.sortType = .descendent
            } label: {
                Text("Descendent")
            }
            Button(role: .cancel) {
                scoresVM.sortType = .none
            } label: {
                Text("Cancel")
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ScoresVM())
    }
}


