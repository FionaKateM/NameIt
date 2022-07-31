//
//  MainContainerView.swift
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

struct MainContainerView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //    @State private var word: String = ""
    //    @FocusState private var focus: FocusableField?
    @StateObject var settings = GameSettings()
    @State private var selectedID = "GiqtSWNG6hfo84mkHpHD"
    //    private var tempListData: List?
    //    @State private var previousLists: [List] = []
    //    @State private var todaysID = ""
    
    var body: some View {
        VStack {
            Text("Name It")
                .environmentObject(settings)
            
            if settings.gameStatus == .started || settings.gameStatus == .ended {
                ActiveGameView()
                    .environmentObject(settings)
            } else if settings.gameStatus == .notStarted {
                Button("Play today's game") {
                    Task {
                        await startGame()
                    }
                }
            }
            
        }
    }
    
    @MainActor
    func fetchSong(id: String) async {
        print("fetch song")
        let db = Firestore.firestore()
        let docRef = db.collection("songs").document(id)
        
        do {
            let song = try await docRef.getDocument(as: Song.self)
            self.settings.song = song
            getWordsList(lyrics: self.settings.song?.lyrics ?? "")
        }
        catch {
            print("error list could not be initialised: \(error.localizedDescription)")
        }
    }
    
    func getWordsList(lyrics: String) {
        // makes lyrics lowercase
        let lowercase = lyrics.lowercased()
        // removes punctuation
        let noPunct = lowercase.filter("abcdefghijklmnopqrstuvwxyz ".contains)
        // splits into set
        let set = Set(noPunct.components(separatedBy: " "))
        // set becomes dictionary keys and values
        for word in set {
            settings.unguessedWords[word] = [word]
            settings.allSynonyms.append(word)
        }
        // checks for synonyms (eg. don't and dont) and add them to the appropriate dictionary key and also adds them to an 'all synonyms' list for quick reference
        for key in settings.unguessedWords.keys {
            if let array = synonyms[key] {
                settings.unguessedWords[key]?.append(contentsOf: array)
                settings.allSynonyms.append(contentsOf: array)
            }
        }
    }
    
    func startGame() async {
        print("start game")
        await fetchSong(id: selectedID)
        settings.correctAnswersGiven = []
        //        word = ""
        settings.gameStatus = .started
        settings.timeRemaining = settings.song?.timer ?? 0
        settings.gameID = selectedID
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
        //                    ActiveGameView.focus = .word
        //                }
        getAllGameData(id: selectedID)
        getColors()
        
    }
    
    func testAdd(song: Song) {
        print("adding test song: \(song.title)")
        let db = Firestore.firestore()
        let collectionRef = db.collection("songs")
        do {
            let newDocReference = try collectionRef.addDocument(from: song)
            print("Song stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error)
        }
    }
    
    func calculateRows() -> Int {
        let lines =  settings.song?.lyrics.components(separatedBy:"\n") ?? []
        return lines.count
    }
    
    func getRows() -> [String] {
        let tempRows = settings.song?.lyrics.components(separatedBy: "\n") ?? []
        var rows:[String] = []
        for row in tempRows {
            rows.append(row.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        print("rows: \(rows)")
        return rows
    }
    
    func getAllGameData(id: String) {
        var globalData = GlobalGameData(id: id, totalPlayers: 0, words: [:], finishTimes: [:])
        print("fetch game data")
        let db = Firestore.firestore()
        db.collection("events").whereField("gameID", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                print("getting documents")
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dict = document.data()
                        // finish times
                        if let finishTime = dict["time"] as? Int {
                            globalData.finishTimes[finishTime, default: 1] += 1
                        }
                        // words
                        if let words = dict["guessedWords"] as? [String: Int] {
                            print("words: \(words)")
                            for word in words {
                                globalData.words[word.key, default: word.value] += word.value
                            }
                        } else {
                            print("dict words: \(dict["words"])")
                        }
                        
                        settings.arrayOfWords = getArrayOfWords(settings: settings)
                        
                        print("global data: \(globalData)")
                        // total players
                        globalData.totalPlayers = querySnapshot!.documents.count
                        
                        //                    print("\(document.documentID) => \(document.data())")
                        
                    }
                    settings.globalGameData = globalData
                    getColors()
                }
            }
        
    }
    
    func getColors(){
        print("colors start: \(settings.globalGameData.words)")
        var colors:[String: Color] = [:]
        let max = settings.globalGameData.words.values.max() ?? 1
        for word in settings.globalGameData.words {
            let value = 0.2 + ((Double(word.value) / Double(max))*0.8)
            let color = Color("Green")
            colors[word.key] = color.opacity(value)
        }
        settings.wordColors = colors
        print("settings word Colors: \(settings.wordColors)")
    }
    
    
}

