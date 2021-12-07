//
//  RowVM.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 7/12/21.
//

import SwiftUI

final class RowVM: ObservableObject {
    @Published var cover: UIImage?
    
    func scoreCover(score: Scores) -> Image {
        if let newCover = cover {
            return Image(uiImage: newCover)
                .resizable()
        } else {
            return Image(score.cover)
                .resizable()
        }
    }
    
    func loadCover(id: Int) {
        cover = PersistenceModel.loadImage(id: id)
    }
}
