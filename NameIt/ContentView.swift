//
//  ContentView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 03/07/2022.
//

import SwiftUI
import CoreData

enum FocusableField: Hashable {
    case word
}

enum InputType {
    case text
    case numerical
}

struct List: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var question: String
    var words: [String]
    var timer: Int
    var inputType: InputType
}

struct ContentView: View {
    
    @State var timeRemaining = 0
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    var list: List = List(id: "001", title: "Colours of the Rainbow", question: "Name all the colours of the rainbow", words: ["blue", "green", "orange", "red", "yellow", "indigo", "violet"], timer: 60, inputType: .text)
    @State private var word: String = ""
    @FocusState private var focus: FocusableField?
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    private var answerArray: [String]
    @State var correctAnswersGiven: [String] = []
    
    init() {
        answerArray = list.words
    }
    
    var body: some View {
        
        NavigationView {
            if gameStarted {
                VStack{
                    Spacer()
                    Text("\(timeRemaining)")
                                .onReceive(timer) { _ in
                                    if timeRemaining > 0 {
                                        timeRemaining -= 1
                                    }
                                }
                    Text(list.question)
                    Spacer()
                    HStack{
                        Spacer()
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
                    Text(correctAnswersGiven.joined(separator:", " ))
                    Spacer()
                }
                .onChange(of: word) { newValue in
                    checkWord()
                }
                .onChange(of: timeRemaining) { newValue in
                    timerCheck()
                }
                
            } else if gameEnded {
                VStack {
                if answerArray.count == correctAnswersGiven.count {
                    Text("well done getting them all")
                } else if timeRemaining == 0 {
                    Text("Time ran out")
                } else {
                    Text("You gave up? :(")
                }
                    Button("Start new game") {
                        startGame()
                    }
                }
                
                
            } else {
                Button("Start game") {
                    startGame()
                }
            }
        }
    }
    private func checkWord() {
        if answerArray.contains(word.lowercased()) && !correctAnswersGiven.contains(word.lowercased()){
            correctAnswersGiven.append(word.lowercased())
            clearWord()
        } else if answerArray.count == correctAnswersGiven.count {
            endGame()
        }
    }
    
    private func clearWord() {
        word = ""
    }
    
    private func startGame() {
        correctAnswersGiven = []
        word = ""
        gameStarted = true
        timeRemaining = list.timer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            focus = .word
        }
    }
    
    private func timerCheck() {
        if timeRemaining == 0 {
            endGame()
        }
    }
    
    private func endGame() {
        gameStarted = false
        gameEnded = true
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
