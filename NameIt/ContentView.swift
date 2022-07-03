//
//  ContentView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 03/07/2022.
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

struct List: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var question: String
    var words: [String]
    var timer: Int
    var inputType: InputType
}

class GameSettings: ObservableObject {
    @Published var timeRemaining = 0
    @Published var gameStarted = false
    @Published var gameEnded = false
    @Published var list: List?
    @Published var correctAnswersGiven: [String] = []
    
//    init(list: List) {
//        self.list = list
//    }
}

struct ContentView: View {
    
    @State var timeRemaining = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var possibleListsArray:[String] = []
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var word: String = ""
    @FocusState private var focus: FocusableField?
    @StateObject var settings = GameSettings()
    @State private var selectedID = ""
    private var tempListData: List?
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Name It")
                //                    .onAppear {
                //                        fetchList(id: "CuMTnVRBtVWfW8SsjOfW")
                ////                        testAddList()
                //                    }
                if settings.gameStarted {
                    ActiveSoloGameView()
                } else if settings.gameEnded {
                    VStack {
                        if settings.list?.words.count == settings.correctAnswersGiven.count {
                            Text("well done getting them all")
                        } else if timeRemaining == 0 {
                            Text("Time ran out")
                        } else {
                            Text("You gave up? :(")
                        }
                        Button("Start new game") {
                            //                            startGame()
                            
                        }
                    }
                } else {
                    Button("Start game") {
                        selectedID = "CuMTnVRBtVWfW8SsjOfW"
                        startGame()
                    }
                }
                
            }
            .environmentObject(settings)
        }
    }
    
    private func startGame() {
        fetchList(id: selectedID)
        settings.correctAnswersGiven = []
        word = ""
        settings.gameStarted = true
        settings.timeRemaining = settings.list?.timer ?? 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            focus = .word
        }
    }
    
    func fetchList(id: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("lists").document(id)
        
        docRef.getDocument(as: List.self) { result in
            switch result {
            case .success(let list):
                self.settings.list = list
                print("settings.list updated: \(settings.list?.id)")
            case .failure(let error):
                print("error list could not be initialised: \(error.localizedDescription)")
            }
        }
    }
    
    func testAddList() {
        print("adding test list")
        let db = Firestore.firestore()
        let collectionRef = db.collection("lists")
        do {
            let newDocReference = try collectionRef.addDocument(from: self.settings.list)
            print("Book stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



