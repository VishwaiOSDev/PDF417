//
//  ContentView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI

struct ContentView: View {
    
    var displayList = DisplayLists()
    
    var body: some View {
        TabView{
            DisplayListView(filter: .box)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Items")
                }
        }.environmentObject(displayList)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
