//
//  ActiveGameView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import SwiftUI

struct ActiveGameView: View {
    @EnvironmentObject var settings: GameSettings
    @FocusState private var focus: FocusableField?
    @State private var word: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text("\(settings.timeRemaining)")
            .onReceive(timer) { _ in
                if settings.timeRemaining > 0 {
                    settings.timeRemaining -= 1
                } else {
                    settings.gameStatus = .ended
                }
            }
        TextField("Type your answer", text: $word)
            .disableAutocorrection(true)
            .textCase(.lowercase)
            .textInputAutocapitalization(.never)
            .padding(.horizontal)
            .textFieldStyle(.roundedBorder)
            .focused($focus, equals: .word)
        LyricsView(rows: getRows())
            .onChange(of: word) { newValue in
                checkWord()
            }
    }
    
    func getRows() -> [String] {
        let tempRows = settings.song?.lyrics.components(separatedBy: "\n") ?? []
        var rows:[String] = []
        for row in tempRows {
            rows.append(row.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return rows
    }
    
    private func checkWord() {
        let simplifiedWord = word.lowercased().filter("abcdefghijklmnopqrstuvwxyz ".contains)
        if settings.allSynonyms.contains(simplifiedWord) {
            for (k, i) in settings.unguessedWords {
                if i.contains(simplifiedWord) {
                    settings.correctAnswersGiven.append(k)
                    for synonym in i {
                        if let index = settings.allSynonyms.firstIndex(of: synonym) {
                            settings.allSynonyms.remove(at: index)
                        }
                    }
                }
            }
            word = ""
        }
    }
}

struct ActiveGameView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveGameView()
    }
}
