//
//  ScoresVM.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

enum SortType {
    case ascendent, descendent, none
}

final class ScoresVM: ObservableObject {
    // Los @Published siempre deben estar inicializados
    @Published var search = ""
    @Published var sortType: SortType = .none
    
    @Published var scores:[Scores] = [] {
        // Cada vez que se modifique el array de scores se realizará el guardado
        didSet {
            if !scores.isEmpty {
                print("Se va realizar el guardado")
                PersistenceModel.saveModel(filename: "scoresdata", data: scores)
            }
        }
    }
    @Published var selectedScore:Scores?
    
    var featuredScores: [Scores] {
        scores.filter {
            isFeatured(score: $0)
        }
    }
    
    // Cada vez que se refresca la interfaz se refrescan los valores de search, sortType o score y eso produce que se modifique el valor de scoresSource
    var scoresSource: [Scores] {
        switch sortType {
        case .ascendent:
            return filterScores.sorted {
                $0.title < $1.title
            }
        case .descendent:
            return filterScores.sorted {
                $0.title > $1.title
            }
        case .none:
            return filterScores.sorted {
                $0.id < $1.id
            }
        }
    }
    
    // Las variables calculadas no hace falta ponerlos con el @Published porque cada vez que se modifica el valor de un @Published se van a actualizar
    var filterScores: [Scores] {
        if search.isEmpty {
            return scores
        } else {
            return scores.filter {
                $0.title.contains(search)
            }
        }
    }
    
    init() {
        scores = PersistenceModel.loadModel(filename: "scoresdata", type: Scores.self)
    }
    
    func deleteScore() {
        if let score = selectedScore {
            withAnimation {
                scores.removeAll() {
                    $0.id == score.id
                }
            }
            PersistenceModel.deleteImage(id: score.id)
        }
    }
    
    func updateScore(score: Scores) {
        if let index = scores.firstIndex(where: { $0.id == score.id }) {
            scores[index] = score
        }
    }
    
    func toggleFeatured(score: Scores) {
        if let index = scores.firstIndex(where: { $0.id == score.id }) {
            if let featured = scores[index].featured {
                scores[index].featured = !featured
            } else {
                scores[index].featured = true
            }
        }
    }
    
    func isFeatured(score: Scores) -> Bool {
        if let index = scores.firstIndex(where: { $0.id == score.id }), let featured = scores[index].featured {
            return featured
        }
        return false
    }
}
