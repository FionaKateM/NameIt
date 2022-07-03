//
//  ActiveSoloGameView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 03/07/2022.
//

import SwiftUI

struct ActiveSoloGameView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var word: String = ""
    @FocusState private var focus: FocusableField?
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack{
            
            Text("\(settings.timeRemaining)")
                .onReceive(timer) { _ in
                    if settings.timeRemaining > 0 {
                        settings.timeRemaining -= 1
                    }
                }
            Text(settings.list?.question ?? "no question loaded")
            Spacer()
            HStack{
                
                TextField("Type your answer", text: $word)
                    .disableAutocorrection(true)
                    .textCase(.lowercase)
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: .word)
                Button {
                    clearWord()
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                Spacer()
            }
            Spacer()
            Button("Give up") {
                endGame()
            }
            Text(settings.correctAnswersGiven.joined(separator:", " ))
                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    focus = .word
                }
                }
            
        }

        .onChange(of: word) { newValue in
            checkWord()
        }
        .onChange(of: settings.timeRemaining) { newValue in
            timerCheck()
        }
    }
    
//    private func startGame() {
//        fetchList(id: selectedID)
//        settings.correctAnswersGiven = []
//        word = ""
//        settings.gameStarted = true
//        settings.timeRemaining = settings.list.timer
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//            focus = .word
//        }
//    }
//    
//    func fetchList(id: String) {
//        let db = Firestore.firestore()
//        let docRef = db.collection("lists").document(id)
//        
//        docRef.getDocument(as: List.self) { result in
//            switch result {
//            case .success(let list):
//                self.settings.list = list
//                print("settings.list updated: \(settings.list.id)")
//            case .failure(let error):
//                print("error list could not be initialised: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func checkWord() {
        if settings.list?.words.contains(word.lowercased()) ?? true && !settings.correctAnswersGiven.contains(word.lowercased()){
            settings.correctAnswersGiven.append(word.lowercased())
            clearWord()
        } else if settings.list?.words.count == settings.correctAnswersGiven.count {
            endGame()
        }
    }
    
    private func clearWord() {
        word = ""
    }
    
    private func endGame() {
        settings.gameStarted = false
        settings.gameEnded = true
    }
    
    private func timerCheck() {
        print("timer check")
        if settings.timeRemaining == 0 {
            endGame()
        }
    }
}

//struct ActiveSoloGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveSoloGameView(list: List(id: "001", title: "Colours of the Rainbow", question: "Name all the colours of the rainbow", words: ["blue", "green", "orange", "red", "yellow", "indigo", "violet"], timer: 60, inputType: .text))
//    }
//}
