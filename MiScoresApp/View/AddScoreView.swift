//
//  AddScoreView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

struct AddScoreView: View {
    @Binding var showAdd: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Title")
                    Text("Composer")
                } header: {
                    Text("Enter the score data")
                }
            }
            .navigationTitle("Add Score")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAdd.toggle()
                    } label: {
                        Text("Close")
                    }

                }
            }
        }
    }
}

struct AddScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddScoreView(showAdd: .constant(true))
    }
}
