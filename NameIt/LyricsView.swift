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
    
    var body: some View {
        ScrollView {
            ForEach(rows, id: \.self) {
                Spacer()
                let array = $0.components(separatedBy: " ")
                GeometryReader { metrics in
                    HStack {
                        Spacer()
                        ForEach(array, id:\.self) { word in
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
                    
                    .frame(minWidth: 0, maxWidth: metrics.size.width * 0.98, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding(3)
                Spacer()
            }
        }
    }
    
}

