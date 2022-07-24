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
    
    var body: some View {
        VStack {
            Text("gameEnded")
                .onAppear {
                    fulfilDataEvent()
                }
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
    }
}

