//
//  FirebaseFunctions.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 24/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import SwiftUI


func gameEventPost(data: DataEvent) {
    
    let db = Firestore.firestore()
    let collectionRef = db.collection("events")
    do {
        let newDocReference = try collectionRef.addDocument(from: data)
        print("Event stored with new document reference: \(newDocReference)")
    }
    catch {
        print(error)
    }
}

func getGameData(id: String) -> GlobalGameData {
    return GlobalGameData(id: id, totalPlayers: 0, words: [:], finishTimes: [:])
}

//db.collection("cities").whereField("capital", isEqualTo: true)
//    .getDocuments() { (querySnapshot, err) in
//        if let err = err {
//            print("Error getting documents: \(err)")
//        } else {
//            for document in querySnapshot!.documents {
//                print("\(document.documentID) => \(document.data())")
//            }
//        }
//}

