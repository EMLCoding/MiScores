//
//  Model.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import Foundation
import UIKit

struct Scores: Codable, Identifiable {
    let id: Int
    let title: String
    let composer: String
    let year: Int
    let length: Double
    let cover: String
    // Si se ponen valores opcionales no es necesario que estén en el JSON de datos de carga
    var featured: Bool?
}

struct PersistenceModel {
    static func loadModel<ModelType:Codable & Identifiable>(filename: String, type: ModelType.Type) -> [ModelType] {
        guard var url = Bundle.main.url(forResource: filename, withExtension: "json"), let urlDoc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        let fileURL = urlDoc.appendingPathComponent(filename).appendingPathExtension("json")
        // Se comprueba si existe el fichero de guardado del json. Si existe coge el archivo creado por la app, sino utiliza el json original
        if FileManager.default.fileExists(atPath: fileURL.path) {
            url = fileURL
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([ModelType].self, from: data)
        } catch {
            print("Error en la carga \(error)")
            return []
        }
    }
    
    static func saveModel<ModelType:Codable>(filename: String, data: ModelType) {
        // Esta es la ruta donde se tiene permisos para escribir en la memoria que tendrá esta app en cada dispositivo. El valor de url va cambiando continuamente, para que no se pueda guardar. Cada vez que se quiere llamar a un archivo en esta carpeta hay que llamar a FileManager.default.urls
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = url.appendingPathComponent(filename).appendingPathExtension("json")
        
        Task(priority: .background) {
            do {
                let json = try JSONEncoder().encode(data)
                // .atomic = evita que se pueda modificar los datos al escribirlos en el archivo
                // .completeFileProtection: añade una clave de cifrado unica para cada archivo. Cada vez que se bloquea el dispositivo se vuelve a cifrar y solo sera utilizable con el dispositivo desbloqueado
                try json.write(to: fileURL, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error en la carga \(error)")
            }
        }
    }
    
    static func saveImage(image: UIImage, id: Int) {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = url.appendingPathComponent("cover_\(id)").appendingPathExtension("jpg")
        Task(priority: .background) {
            do {
                // Cuanto menor es el numero de compressionQuality mayor es la compresion
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    try imageData.write(to: fileURL, options: [.atomic, .completeFileProtection])
                }
            } catch {
                print("Error grabando la imagen \(error)")
            }
        }
    }
    
    static func loadImage(id: Int) -> UIImage? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = url.appendingPathComponent("cover_\(id)").appendingPathExtension("jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Error en la carga de la imagen")
            }
        }
        return nil
    }
    
    static func deleteImage(id: Int) {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = url.appendingPathComponent("cover_\(id)").appendingPathExtension("jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error al eliminar la imagen")
            }
            
        }
    }
    
    static let testScore = Scores(id: 1, title: "Star Wars", composer: "John Williams", year: 1977, length: 77, cover: "StarWars", featured: false)
}
