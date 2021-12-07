//
//  ScoreRowView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

struct ScoreRowView: View {
    @EnvironmentObject var scoresVM: ScoresVM
    @ObservedObject var rowVM = RowVM()
    
    let score: Scores
    
    @State var showShared = false
    @State var cover: UIImage?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(score.title)")
                    .bold()
                Text("\(score.composer)")
                    .font(.footnote)
                Spacer()
                Text("\(score.year.spanishFormat), \(score.length.formatted(.number.precision(.fractionLength(1)))) min.")
                    .font(.subheadline)
            }
            Spacer()
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    rowVM.scoreCover(score: score)
                        .scaledToFit()
                        .frame(width: 90)
                        .cornerRadius(20)
                }
                .overlay {
                    Image(systemName: scoresVM.isFeatured(score: score) ? "star.fill" : "star")
                        .padding(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
                
                Image(score.composer)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.red, lineWidth: 2)
                    }
                    .padding(-5)
            }
        }
        .contextMenu {
            Button {
                showShared.toggle()
            } label: {
                Label("Share score", systemImage: "square.and.arrow.up")
            }
        }
        .sheet(isPresented: $showShared) {
            // Para poder añadir la foto a la libreria de fotos desde la pantalla de compartir es necesario agregar el siguiente permiso al info.plist:  Privacy - Photo Library Additions Usage Description
            ActivityView(items: [UIImage(named: "\(score.cover)") as Any])
        }
        .task {
            // Si no se hace asi no se refresca automaticamente la imagen en el listado de Scores cuando la imagen ha sido modificada desde el detalle de uno de los scores.
            rowVM.loadCover(id: score.id)
        }
    }
}

struct ScoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreRowView(score: PersistenceModel.testScore)
            .frame(width: 390.0, height: 100.0)
            .environmentObject(ScoresVM())
    }
}
