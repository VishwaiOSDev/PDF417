//
//  ContentView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        DisplayListView(filter: .box)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
