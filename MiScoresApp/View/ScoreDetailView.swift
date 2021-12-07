//
//  ScoreDetailView.swift
//  MiScoresApp
//
//  Created by Eduardo Martin Lorenzo on 21/11/21.
//

import SwiftUI

struct ScoreDetailView: View {
    @EnvironmentObject var scoresVM: ScoresVM
    @ObservedObject var scoreDetailVM = ScoreDetailVM()
    
    @Environment(\.dismiss) var dismiss
    
    enum Field {
        case title, composer, year, length
    }
    @FocusState var actualField: Field?
    
    @State var showChangeCover = false
    
    let score: Scores
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Title").bold()
                    // El prompt es para el Mac
                    TextField("Enter the title", text: $scoreDetailVM.title, prompt: Text("Title"))
                        .focused($actualField, equals: .title)
                        .submitLabel(.next)
                }
                VStack(alignment: .leading) {
                    Text("Composer").bold()
                    // El prompt es para el Mac
                    TextField("Enter the composer", text: $scoreDetailVM.composer, prompt: Text("Composer"))
                        .focused($actualField, equals: .composer)
                        .textContentType(.name)
                        .submitLabel(.next)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Year").bold()
                        // El prompt es para el Mac
                        TextField("Enter the title",
                                  value: $scoreDetailVM.year,
                                  format: .number.precision(.integerLength(4)),
                                  prompt: Text("Year"))
                            .focused($actualField, equals: .year)
                            .keyboardType(.numberPad)
                            .submitLabel(.next)
                    }
                    VStack(alignment: .leading) {
                        Text("Length").bold()
                        // El prompt es para el Mac
                        TextField("Enter the length",
                                  value: $scoreDetailVM.length,
                                  format: .number.precision(.fractionLength(1)),
                                  prompt: Text("Length"))
                            .focused($actualField, equals: .length)
                            .keyboardType(.numberPad)
                            .submitLabel(.done)
                    }
                }
            } header: {
                Text("Scores data")
            }
            Section {
                VStack {
                    // Si se ha modificado la imagen entonces se usa la nueva
                    if let newCover = scoreDetailVM.cover {
                        Image(uiImage: newCover)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    } else {
                        Image("\(score.cover)")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                    }
                    Button {
                        showChangeCover.toggle()
                    } label: {
                        Text("Change cover")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                }
                .padding(.vertical)
            } header: {
                Text("Score cover")
            }
            .sheet(isPresented: $showChangeCover) {
                PHPickerView(cover: $scoreDetailVM.cover)
            }
            .onSubmit {
                next()
            }
            .alert("Validation error", isPresented: $scoreDetailVM.showAlert, actions: {
                Button {
                    scoreDetailVM.alertMessage = ""
                } label: {
                    Text("OK")
                }
            }, message: {
                Text("\(scoreDetailVM.alertMessage)")
            })
            .onTapGesture {
                hideKeyboard()
            }
            .task {
                // El task se ejecuta cuando se carga la vista y puede ejecutar tareas asíncronas
                scoreDetailVM.initialLoad(score: score)
            }
            .textFieldStyle(.roundedBorder)
            .navigationTitle("Edit a score")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        actualField = nil
                        if let new = scoreDetailVM.saveScore(score: score) {
                            scoresVM.updateScore(score: new)
                            dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button {
                            previous()
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            next()
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        Spacer()
                        Button {
                            actualField = nil
                        } label: {
                            Image(systemName: "keyboard")
                        }
                    }
                }
            }
        }
    }
    
    func next() {
        switch actualField {
        case .title:
            actualField = .composer
        case .composer:
            actualField = .year
        case .year:
            actualField = .length
        case .length:
            actualField = nil
        default: ()
        }
    }
    
    func previous() {
        switch actualField {
        case .title:
            actualField = nil
        case .composer:
            actualField = .title
        case .year:
            actualField = .composer
        case .length:
            actualField = .year
        default: ()
        }
    }
}

struct ScoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScoreDetailView(score: PersistenceModel.testScore)
                .environmentObject(ScoresVM())
        }
    }
}
