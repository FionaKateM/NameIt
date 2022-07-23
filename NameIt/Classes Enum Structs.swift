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
}
