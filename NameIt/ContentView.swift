////
////  ContentView.swift
////  NameIt
////
////  Created by Fiona Kate Morgan on 03/07/2022.
////
//
//import SwiftUI
//import CoreData
//import Foundation
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import Firebase
//
//enum FocusableField: Hashable {
//    case word
//}
//
//enum InputType: Int, Codable {
//    case text
//    case numerical
//}
//
//struct List: Codable, Identifiable, Hashable {
//    @DocumentID var id: String?
//    var title: String
//    var question: String
//    var words: [String:[String]]
//    var timer: Int
//    var inputType: InputType
//    var date: Date
//    var active: Bool
//}
//
//class GameSettings: ObservableObject {
//    @Published var timeRemaining = 0
//    @Published var gameStarted = false
//    @Published var gameEnded = false
//    @Published var list: List?
//    @Published var correctAnswersGiven: [String] = []
//}
//
//struct ContentView: View {
//
//    //    @State var timeRemaining = 0
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    private var possibleListsArray:[String] = []
//
//    @Environment(\.managedObjectContext) private var viewContext
//
//
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//    @State private var word: String = ""
//    @FocusState private var focus: FocusableField?
//    @StateObject var settings = GameSettings()
//    @State private var selectedID = ""
//    private var tempListData: List?
//    @State private var previousLists: [List] = []
//    @State private var todaysID = ""
//    //    private var listToBeAdded = List(title: "Spongebob Theme", question: "Name all the words in the Spongebob Squarepants Theme song", words: ["Who", "lives"], timer: 120, inputType: .text)
//
//    var body: some View {
//
//        NavigationView {
//            VStack {
//                Text("Name It")
//                    .onAppear {
//                        //                        testAddList()
//                        //                        testAddSongList()
//                        Task {
//                            await loadListArray()
//                            for list in previousLists {
//                                print("\(list.date)")
//                                if Calendar.current.isDateInToday(list.date) {
//                                    todaysID = list.id ?? ""
//
//                                    if let i = previousLists.firstIndex(of: list) {
//                                        previousLists.remove(at: i)
//                                    }
//                                }
//                                print("todaysID: \(todaysID)")
//                            }
//                        }
//
//                    }
//                if settings.gameStarted {
//                    ActiveSoloGameView()
//                } else if settings.gameEnded {
//                    VStack {
//                        if settings.list?.words.count == settings.correctAnswersGiven.count {
//                            Text("well done getting them all")
//                        } else if settings.timeRemaining == 0 {
//                            VStack {
//                                let total = settings.list?.words.keys.count
//                                var missedWordsVisible = false
//                                Text("Time ran out")
//                                Text("You got \(settings.correctAnswersGiven.count)/\(total ?? 0)")
//                                if missedWordsVisible {
//                                    Text("missing words will show here")
//                                } else {
//                                    Button("Show missed words") {
//                                        missedWordsVisible = true
//                                    }
//                                }
//                            }
//                        } else {
//                            Text("You gave up? :(")
//                        }
//                        Button("Start random game") {
//                            selectRandomGame()
//                            Task {
//                                await startGame()
//                            }
//                        }
//                    }
//
//                } else {
//                    VStack {
//                        Button("Today's list") {
//                            selectedID = todaysID
//                            Task {
//                                await startGame()
//                            }
//                        }
//                        Spacer()
//                        Text("Previous games")
//                        ForEach(previousLists, id: \.self) { list in
//                            Button(list.title) {
//                                selectedID = list.id ?? "unknown"
//                                Task {
//                                    await startGame()
//                                }
//                            }
//                        }
//                        Spacer()
//                        Button("Start random game") {
//                            selectRandomGame()
//                            Task {
//                                await startGame()
//                            }
//                        }
//                    }
//                }
//            }.environmentObject(settings)
//        }
//    }
//
//    func startGame() async {
//        await fetchList(id: selectedID)
//        settings.correctAnswersGiven = []
//        word = ""
//        settings.gameStarted = true
//        settings.timeRemaining = settings.list?.timer ?? 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//            focus = .word
//        }
//    }
//    @MainActor
//    func fetchList(id: String) async {
//        let db = Firestore.firestore()
//        let docRef = db.collection("lists").document(id)
//
//        do {
//            let list = try await docRef.getDocument(as: List.self)
//            self.settings.list = list
//        }
//        catch {
//            print("error list could not be initialised: \(error.localizedDescription)")
//        }
//    }
//
//    func loadListArray() async {
//        let db = Firestore.firestore()
//        let docRef = db.collection("lists").whereField("active", isEqualTo: true)
//
//        do {
//            let snapshot = try await docRef.getDocuments()
//            for i in snapshot.documents {
//                do {
//                    let l = try i.data(as: List.self)
//                    self.previousLists.append(l)
//                }
//                catch {
//                    print("list could not be made when loading list array")
//                }
//            }
//            //            lists = snapshot.documents
//        }
//        catch {
//            print("error list could not be initialised: \(error.localizedDescription)")
//        }
//    }
//
//    func selectRandomGame() {
//        if previousLists.count > 0 {
//            print("list IDs: \(previousLists.description)")
//            let random = Int.random(in: 0..<previousLists.count)
//            selectedID = previousLists[random].id!
//            print("selected ID: \(selectedID)")
//        } else {
//            selectedID = "CuMTnVRBtVWfW8SsjOfW"
//        }
//    }
//
//    //    func testAddList() {
//    //        print("adding test list")
//    //        let db = Firestore.firestore()
//    //        let collectionRef = db.collection("lists")
//    //        do {
//    //            let newDocReference = try collectionRef.addDocument(from: self.listToBeAdded)
//    //            print("Book stored with new document reference: \(newDocReference)")
//    //        }
//    //        catch {
//    //            print(error)
//    //        }
//    //    }
//
//    //    func testAddSongList() {
//    //        let allWords = "Are you ready kids I can't hear you aye aye Captain Ooh Who lives in a pineapple under the sea Absorbant and yellow and porous is he If nautical nonsense be something you wish Then drop on the deck and flop like a fish ready Spongebob Squarepants"
//    //        let set = Set(allWords.lowercased().components(separatedBy: " "))
//    //        var words: [String: [String]] = [:]
//    //        for item in set {
//    //            words[item] = [item]
//    //        }
//    //        let list = List(title: "SpongeBob SquarePants", question: "Name all the words in the Spongebob Squarepants song", words: words, timer: 60, inputType: .text, date: Date.now, active: true)
//    //        let db = Firestore.firestore()
//    //                let collectionRef = db.collection("lists")
//    //                do {
//    //                    let newDocReference = try collectionRef.addDocument(from: list)
//    //                    print("Book stored with new document reference: \(newDocReference)")
//    //                }
//    //                catch {
//    //                    print(error)
//    //                }
//    //    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//
//
