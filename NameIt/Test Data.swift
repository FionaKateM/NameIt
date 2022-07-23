//
//  Test Data.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 23/07/2022.
//

import Foundation

func getDate(year: Int, month: Int, day: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    
    let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
    
    if let date = userCalendar.date(from: dateComponents) {
        return date
    } else {
        return Date.now
    }
}



let shakeItOff = Song(title: "Shake it off", artist: "Taylor Swift", lyrics: """
                     I stay out too late
                     Got nothing in my brain
                     That's what people say, mmm mmm
                     That's what people say, mmm mmm
                     I go on too many dates
                     But I can't make them stay
                     At least that's what people say, mmm mmm
                     That's what people say, mmm mmm
                     But I keep cruisin'
                     Can't stop, won't stop movin'
                     It's like I got this music in my mind
                     Sayin', "It's gonna be alright"
                     'Cause the players gonna play, play, play, play, play
                     And the haters gonna hate, hate, hate, hate, hate
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off
                     Heartbreakers gonna break, break, break, break, break
                     And the fakers gonna fake, fake, fake, fake, fake
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off
                     I never miss a beat
                     I'm lightnin' on my feet
                     And that's what they don't see, mmm mmm
                     That's what they don't see, mmm mmm
                     I'm dancin' on my own (Dancin' on my own)
                     I make the moves up as I go (Moves up as I go)
                     And that's what they don't know, mmm mmm
                     That's what they don't know, mmm mmm
                     But I keep cruisin'
                     Can't stop, won't stop groovin'
                     It's like I got this music in my mind
                     Sayin', "It's gonna be alright"
                     'Cause the players gonna play, play, play, play, play
                     And the haters gonna hate, hate, hate, hate, hate
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off
                     Heartbreakers gonna break, break, break, break, break
                     And the fakers gonna fake, fake, fake, fake, fake
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off
                     Shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     Hey, hey, hey
                     Just think, while you've been gettin' down and out about the liars
                     And the dirty, dirty cheats of the world
                     You could've been gettin' down
                     To this sick beat
                     My ex man brought his new girlfriend
                     She's like, "Oh my God!" But I'm just gonna shake
                     And to the fella over there with the hella good hair
                     Won't you come on over, baby?
                     We can shake, shake, shake
                     Yeah, oh, oh, oh
                     'Cause the players gonna play, play, play, play, play
                     And the haters gonna hate, hate, hate, hate, hate
                     (Haters gonna hate)
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off
                     Heartbreakers gonna break, break, break, break, break (Mmm)
                     And the fakers gonna fake, fake, fake, fake, fake
                     (And fake, and fake, and fake)
                     Baby, I'm just gonna shake, shake, shake, shake, shake
                     I shake it off, I shake it off (I, I, I)
                     Shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     Shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off (Yeah!)
                     Shake it off, I shake it off
                     I, I, I shake it off, I shake it off (You got to)
                     I, I, I shake it off, I shake it off
                     I, I, I shake it off, I shake it off
""", timer: 60, inputType: .text, date: Date.now, active: true, releaseDate: ["UK":getDate(year: 2014, month: 8, day: 19), "US": getDate(year: 2014, month: 8, day: 19)], topChartPosition: ["US":[1: getDate(year: 2014, month: 9, day: 6)], "UK": [1: getDate(year: 2014, month: 8, day: 30)]])
