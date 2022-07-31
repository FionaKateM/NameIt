//
//  GameFunctions.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 31/07/2022.
//

import Foundation

func getRows(settings: GameSettings) -> [String] {
    let tempRows = settings.song?.lyrics.components(separatedBy: "\n") ?? []
    var rows:[String] = []
    for row in tempRows {
        rows.append(row.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    return rows
}

func getArrayOfWords(settings: GameSettings) -> [[String]]{
    let rows = getRows(settings: settings)
    var words:[[String]] = []
    for row in rows {
        let wordsAppend = row.components(separatedBy: " ")
        words.append(wordsAppend)
    }
    print("words: \(words)")
    return words
}

