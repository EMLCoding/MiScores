//
//  FavouriteRowView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 7/12/21.
//

import SwiftUI

struct FavouriteRowView: View {
    @ObservedObject var rowVM = RowVM()
    
    let score: Scores
    
    var body: some View {
        VStack(spacing: 1) {
            rowVM.scoreCover(score: score)
                .scaledToFit()
                .cornerRadius(10)
            VStack {
                Text("\(score.title)").bold()
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Text("\(score.composer)").font(.caption2)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.5)
            .padding(5)
            .padding(.horizontal, 5)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.indigo)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 4, y: 4)
            }
            .foregroundColor(.white)
        }
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.gray.opacity(0.3))
                .shadow(color: .black.opacity(0.5), radius: 4, x: 4, y: 4)
        }
        .task {
            rowVM.loadCover(id: score.id)
        }
    }
}

struct FavouriteRowView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteRowView(score: PersistenceModel.testScore)
    }
}
