//
//  LyricsView.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import SwiftUI

struct LyricsView: View {
    
    @EnvironmentObject var settings: GameSettings
    @State var rows: [String]
    //    @State var scrollLocation = 0
    
    var body: some View {
        ScrollViewReader { scrollView in
            GeometryReader { metrics in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(0..<rows.count) { i in
                            Spacer()
                            let array = rows[i].components(separatedBy: " ")
                            
                            HStack {
                                Spacer()
                                ForEach(0..<array.count) { x in
                                    let word = array[x]
                                    let cleanWord = cleanUp(word: word)
                                    let width = (metrics.size.width / (CGFloat((array.count + 1)))) - 8
                                    if settings.gameStatus == .ended {
                                        Text(word)
                                            .minimumScaleFactor(0.1)
                                            .padding(5)
                                            .frame(minWidth: width, maxWidth: width, minHeight: 20, maxHeight: 20)
                                                                                    .background(settings.wordColors[cleanWord])
                                            .cornerRadius(15)
                                            .foregroundColor(settings.allSynonyms.contains(cleanWord) ? .red : .black)
                                    } else if !settings.allSynonyms.contains(cleanWord) {
                                        Text(word)
                                            .minimumScaleFactor(0.1)
                                            .padding(5)
                                            .frame(minWidth: width, maxWidth: width, minHeight: 20, maxHeight: 20)
                                                                                    .background(settings.wordColors[cleanWord])
                                            .cornerRadius(15)
                                            .foregroundColor(.black)
                                    } else {
                                        Text("")
                                            .minimumScaleFactor(0.1)
                                            .padding(5)
                                            .frame(minWidth: width, maxWidth: width, minHeight: 20, maxHeight: 20)
                                            .background(.gray)
                                            .cornerRadius(15)
                                    }
                                }
                                Spacer()
                            }
                            .id(i)
                            Spacer()
                        }
                    }
                    .frame(minWidth: 0, maxWidth: metrics.size.width * 0.98, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()
                        .onChange(of: settings.lastGuessedWord) { word in
                            scrollView.scrollTo(getScrollLocation())
                        }
                    
                }
            }
        }
        
        
    }
    
    
    func getScrollLocation() -> Int {
        for i in (0..<rows.count) {
            if rows[i].contains(settings.lastGuessedWord) {
                if i > rows.count - 10 {
                    return i
                    //                    return rows.count - 10
                } else {
                    return i
                }
            }
        }
        return 0
    }
    
    
    
}



func cleanUp(word: String) -> String {
    let lowercase = word.lowercased()
    // removes punctuation
    let noPunct = lowercase.filter("abcdefghijklmnopqrstuvwxyz ".contains)
    
    return noPunct
    
}


