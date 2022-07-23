////
////  ActiveSoloGameView.swift
////  NameIt
////
////  Created by Fiona Kate Morgan on 03/07/2022.
////
//
//import SwiftUI
//
//struct ActiveSoloGameView: View {
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @State private var word: String = ""
//    @FocusState private var focus: FocusableField?
//    @EnvironmentObject var settings: GameSettings
//    
//    var body: some View {
//        VStack{
//            
//            Text("\(settings.timeRemaining)")
//                .onReceive(timer) { _ in
//                    if settings.timeRemaining > 0 {
//                        settings.timeRemaining -= 1
//                    }
//                }
//            Text(settings.list?.question ?? "no question loaded")
//            Spacer()
//            HStack{
//                
//                TextField("Type your answer", text: $word)
//                    .disableAutocorrection(true)
//                    .textCase(.lowercase)
//                    .textInputAutocapitalization(.never)
//                    .padding(.horizontal)
//                    .textFieldStyle(.roundedBorder)
//                    .focused($focus, equals: .word)
//                Button {
//                    clearWord()
//                } label: {
//                    Image(systemName: "multiply.circle.fill")
//                }
//                Spacer()
//            }
//            Spacer()
//            Button("Give up") {
//                endGame()
//            }
//            Text(settings.correctAnswersGiven.joined(separator:", " ))
//                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                    focus = .word
//                }
//                }
//            
//        }
//
//        .onChange(of: word) { newValue in
//            checkWord()
//        }
//        .onChange(of: settings.timeRemaining) { newValue in
//            timerCheck()
//        }
//    }
//    
//
//    private func checkWord() {
//        if let dict = settings.list?.words {
//            for (k, i) in dict {
//                if i.contains(word) && !settings.correctAnswersGiven.contains(k) {
//                    settings.correctAnswersGiven.append(k)
//                    clearWord()
//                }
//                if settings.correctAnswersGiven.count == dict.count {
//                    endGame()
//                }
//            }
//        }
//    }
//    
//    private func clearWord() {
//        word = ""
//    }
//    
//    private func endGame() {
//        settings.gameStarted = false
//        settings.gameEnded = true
//    }
//    
//    private func timerCheck() {
//        if settings.timeRemaining == 0 {
//            endGame()
//        }
//    }
//}
//
////struct ActiveSoloGameView_Previews: PreviewProvider {
////    static var previews: some View {
////        ActiveSoloGameView(list: List(id: "001", title: "Colours of the Rainbow", question: "Name all the colours of the rainbow", words: ["blue", "green", "orange", "red", "yellow", "indigo", "violet"], timer: 60, inputType: .text))
////    }
////}
