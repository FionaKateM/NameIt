//
//  Classes Enum Structs.swift
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

enum FocusableField: Hashable {
    case word
}

enum InputType: Int, Codable {
    case text
    case numerical
}

enum gameStatus: Int, Codable {
    case notStarted
    case started
    case ended
}

struct Song: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var title: String
    var artist: String
    var lyrics: String
    var timer: Int
    var inputType: InputType
    var date: Date
    var active: Bool
    var releaseDate: [String: Date]
    var topChartPosition: [String: [Int: Date]]
}

class GameSettings: ObservableObject {
    @Published var timeRemaining = 0
    @Published var gameStatus: gameStatus = .notStarted
    @Published var song: Song?
    @Published var correctAnswersGiven: [String] = [] // lowercase without punctuation
    @Published var correctAnswersArray: [String: String] = [:] // key is the lowercase without punctuation, value is what shows to player in lyrics view
    @Published var unguessedWords: [String: [String]] = [:]
    @Published var allSynonyms: [String] = [] // for quick checking during active game
    @Published var lastGuessedWord = "" // allows scroll view to jump to last guessed word, also allows extra styling
}

struct DataEvent: Codable, Identifiable, Hashable {
    // date: Date, total players: Int, words: [word: Int], guessed words: [0: Int, 1: Int], finishing times (if they get all words): [0: Int, 1: Int]
    @DocumentID var id: String?
    var timestamp = Date.now
    var gameID: String = ""
    var guessedWords: [String: Int] = [:]// string is simplified word, second is 0 if not guessed and 1 if guessed
    var time: Int = 0 // 0 if ran out of time, otherwise value on clock if all words guessed
    var location: String = ""
}
