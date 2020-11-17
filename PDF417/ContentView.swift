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
                    Image(systemName: "shippingbox.fill")
                    Text("Box")
                }
            DisplayListView(filter: .mail)
                .tabItem {
                    Image(systemName: "mail.stack")
                    Text("Mail Items")
                }
            Text("QRCode Scanner")
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
        }.environmentObject(displayList)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
