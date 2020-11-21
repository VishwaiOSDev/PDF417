//
//  DisplayList.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI

class DisplayList : Identifiable , Codable{
    var id = UUID()
    var street = "Apple"
    var postalCode = ""
    var isContacted = true
}


class DisplayLists : ObservableObject{
    
    @Published var people : [DisplayList]
    
    init() {
        self.people = []
    }
}
