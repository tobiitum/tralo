//
//  termine.swift
//  tralo
//
//  Created by Tobias Klingenberg on 17.08.22.
//

import SwiftUI

struct Termin: Identifiable {
    var id = UUID().uuidString
    var text: String
    var date: String
    var time: String
    var place: String
}

var termine = [
    
    Termin(text: "Einkaufen", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Essen", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Führerschein", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Lernen", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Zahnarzt", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Schlafen", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Bürgeramt", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Reise", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Meeting", date: "14.03.2022", time: "14:45",place: "Rewe"),
    Termin(text: "Besprechung", date: "14.03.2022", time: "14:45",place: "Rewe"),

]
