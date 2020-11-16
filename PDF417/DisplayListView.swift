//
//  DisplayListView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI

struct DisplayListView: View {
    
    enum FilterType {
        case box , mail
    }
    
    let filter : FilterType
    var title : String {
        switch filter{
        case .box:
            return "Box"
        case .mail:
            return  "Mail"
        }
    }
    
    var body: some View {
        NavigationView{
            Text("Hello, World!")
                .navigationBarTitle(title)
        }
    }
}

struct DisplayListView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayListView(filter: .box)
    }
}
