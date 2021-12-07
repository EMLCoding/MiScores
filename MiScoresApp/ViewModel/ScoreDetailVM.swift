//
//  ScoreDetailVM.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 25/11/21.
//

import Foundation
import UIKit

final class ScoreDetailVM: ObservableObject {
    @Published var title = ""
    @Published var composer = ""
    @Published var year = 0
    @Published var length = 0.0
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var score: Scores?
    
    @Published var cover: UIImage?
    
    func initialLoad(score: Scores) {
        title = score.title
        composer = score.composer
        year = score.year
        length = score.length
        self.score = score
        self.cover = PersistenceModel.loadImage(id: score.id)
    }
    
    func saveScore(score: Scores) -> Scores? {
        if title.isEmpty {
            alertMessage += "The title cannot be empty.\n"
            title = score.title
        }
        if year < 1900 || year > 2050 {
            alertMessage += "The year must be between 1900 and 2050.\n"
            year = score.year
        }
        if length <= 0 || length > 300 {
            alertMessage += "The length must be between 1 and 300.\n"
            length = score.length
        }
        
        if alertMessage.isEmpty {
            if let image = cover {
                PersistenceModel.saveImage(image: image, id: score.id)
            }
            return Scores(id: score.id, title: title, composer: composer, year: year, length: length, cover: score.cover)
        } else {
            showAlert.toggle()
            return nil
        }
    }
}
