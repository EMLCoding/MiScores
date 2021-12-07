//
//  Extension.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

extension Int {
    var spanishFormat: String {
        self.formatted(.number.locale(Locale(identifier: "es")))
    }
}
  
// Para poder quitar el teclado al pulsar fuera del formulario
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
