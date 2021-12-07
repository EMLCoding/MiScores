//
//  ActivityView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 6/12/21.
//

import SwiftUI

// Esto es para el menu de compartir. Como es de UIKit hay que utilizar lo siguiente
struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    
    // El alias es obligatorio por el protocolo
    typealias UIViewControllerType = UIActivityViewController
    
    // Es obligatorio por el protocolo
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    // Es obligatorio por el protocolo
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No es necesario que tenga nada porque no se va a usar
    }
}

