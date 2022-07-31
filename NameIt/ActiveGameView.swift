//
//  ActiveGameView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import SwiftUI
import Combine

struct ActiveGameView: View {
    @EnvironmentObject var settings: GameSettings
    @FocusState var focus: FocusableField?
    @State private var word: String = ""
    @State private var keyboardHeight: CGFloat = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                
                if settings.gameStatus == .started {
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
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                focus = .word
                            }
                        }
                }
                LyricsView(rows: getRows())
                    .frame(maxHeight: (metrics.size.height))
                    .onChange(of: word) { newValue in
                        checkWord()
                    }
                    .ignoresSafeArea(.keyboard)
                //                    .padding(.bottom, keyboardHeight)
                    .onReceive(Publishers.keyboardHeight) {
                        if self.keyboardHeight < $0 {
                        self.keyboardHeight = $0
                        }

                    }
                Spacer()
                if settings.gameStatus == .ended {
                    GameEndedView(dataEvent: DataEvent())
//                        .frame(minHeight: keyboardHeight, maxHeight: keyboardHeight)
                        
                }
            }
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
        if word.count > 0 {
            let simplifiedWord = word.lowercased().filter("abcdefghijklmnopqrstuvwxyz ".contains)
            if let index = settings.allSynonyms.firstIndex(of: simplifiedWord) {
                if simplifiedWord != settings.lastGuessedWord {
                    settings.lastGuessedWord = simplifiedWord
                }
                settings.allSynonyms.remove(at: index)
                for (k, i) in settings.unguessedWords {
                    if i.contains(simplifiedWord) {
                        settings.correctAnswersGiven.append(k)
                        for synonym in i {
                            if let index = settings.allSynonyms.firstIndex(of: synonym) {
                                settings.allSynonyms.remove(at: index)
                            }
                        }
                        settings.unguessedWords.removeValue(forKey: k)
                    }
                }
                word = ""
            }
        }
        
    }
}
