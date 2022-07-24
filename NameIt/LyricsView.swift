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
        //        ScrollView {
        ScrollViewReader { scrollView in
            //            Button("Scroll to 100") {
            //                scrollView.scrollTo(100, anchor: .top)
            //                print(scrollView)
            //            }
            //            Button("Scroll to 0") {
            //                scrollView.scrollTo(0, anchor: .top)
            //                print(scrollView)
            //            }
            //            Button("Scroll to 50") {
            //                scrollView.scrollTo(50, anchor: .top)
            //                print(scrollView)
            //            }
            //            Button("Scroll to 75") {
            //                scrollView.scrollTo(75, anchor: .top)
            //                print(scrollView)
            //            }
            GeometryReader { metrics in
                ScrollView(.vertical) {
                    VStack {
                        ForEach(0..<rows.count) { i in
                            Spacer()
                            let array = rows[i].components(separatedBy: " ")
                            
                            
                            HStack {
                                Spacer()
                                ForEach(0..<array.count) { x in
                                    let word = array[x]
                                    let width = (metrics.size.width / (CGFloat((array.count + 1)))) - 8
                                    
                                    if settings.allSynonyms.contains(word.lowercased().filter("abcdefghijklmnopqrstuvwxyz ".contains)) {
                                        Text("")
                                            .minimumScaleFactor(0.1)
                                            .padding(5)
                                            .frame(minWidth: width, maxWidth: width, minHeight: 20, maxHeight: 20)
                                            .background(.gray)
                                            .cornerRadius(15)
                                    } else {
                                        Text(word)
                                            .minimumScaleFactor(0.1)
                                            .padding(5)
                                            .frame(minWidth: width, maxWidth: width, minHeight: 20, maxHeight: 20)
                                            .background(.pink)
                                            .cornerRadius(15)
                                    }
                                }
                                Spacer()
                            }
                            .id(i)
                            .frame(minWidth: 0, maxWidth: metrics.size.width * 0.98, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                        }
                        Spacer()
                            .onChange(of: settings.lastGuessedWord) { word in
                                scrollView.scrollTo(getScrollLocation())
                            }
                        
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

