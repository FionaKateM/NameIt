//
//  GameEndedView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import SwiftUI

struct GameEndedView: View {
    @State var dataEvent: DataEvent
    var gameID: String
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
//            Text("guessed words: \(dataEvent.guessedWords)")
            Text("gameEnded")
            .onAppear {
                fulfilDataEvent()
            }
            Text("some text")
        }
    }
    
    func fulfilDataEvent() {
        dataEvent.gameID = gameID
        dataEvent.timestamp = Date.now
        
        for word in settings.correctAnswersGiven {
            dataEvent.guessedWords[word] = 1
        }
        
        for word in settings.unguessedWords {
            dataEvent.guessedWords[word.key] = 0
        }
        
        if dataEvent.guessedWords.keys.count != settings.unguessedWords.count + settings.correctAnswersGiven.count {
            print("numbers don't add up")
            print("guessed words: \(String(describing: dataEvent.guessedWords.count))")
            print("total words: \(settings.unguessedWords.count + settings.correctAnswersGiven.count)")
            
            print(dataEvent.guessedWords)
            print(settings.unguessedWords)
            print(settings.correctAnswersGiven)
        }
    }
}

