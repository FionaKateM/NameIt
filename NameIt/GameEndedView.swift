//
//  GameEndedView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import SwiftUI
import CoreData
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct GameEndedView: View {
    @State var dataEvent: DataEvent
    @EnvironmentObject var settings: GameSettings
    @State var gameScore = GameScore()
    
    var body: some View {
        VStack {
            Text("gameEnded")
                .onAppear {
                    fulfilDataEvent()
                }
            
            Text("Completion: \(String(format: "%.2f", gameScore.songCompletionPercentage))%")
            Text("Unique words: \(String(format: "%.2f", gameScore.uniqueWordPercentage))%")
            Text("Time remaining: \(gameScore.timeRemaining) seconds")
            
            
        }
    }
    
    
    func fulfilDataEvent() {
        dataEvent.gameID = settings.gameID
        dataEvent.timestamp = Date.now
        dataEvent.location = "UK"
        
        for word in settings.correctAnswersGiven {
            
            if word != "" {
                dataEvent.guessedWords[word] = 1
            }
        }
        
        for word in settings.unguessedWords {
            if word.key != "" {
                dataEvent.guessedWords[word.key] = 0
            }
        }
        gameEventPost(data: dataEvent)
        gameScore = getScoring(settings: settings)
    }
}

func getScoring(settings: GameSettings) -> GameScore {
    // Completion %
    var countOfGuessedWords: Double = 0
    var countOfTotalWords: Double = 0
    for row in settings.arrayOfWords {
        for word in row {
            let cleanWord = cleanUp(word: word)
            if settings.correctAnswersGiven.contains(cleanWord) {
                countOfGuessedWords += 1
            }
            countOfTotalWords += 1
        }
    }
    let totalCompletion = (countOfGuessedWords / countOfTotalWords) * 100
    // Unique words %
    //    print("correct answers array: \(settings.correctAnswersArray.keys)")
    let uniqueWords = Double(settings.correctAnswersGiven.count) / (Double(settings.unguessedWords.keys.count) + Double(settings.correctAnswersGiven.count)) * 100
    // time left (if 100%)
    
    var result = GameScore()
    result.timeRemaining = settings.timeRemaining
    result.uniqueWordPercentage = uniqueWords
    result.songCompletionPercentage = totalCompletion
    print("result: \(result)")
    
    return result
}

func dataInsights() {
    // era
    // genre
    // favourite word to guess (if its there)
    // all words you've guessed ever
}
