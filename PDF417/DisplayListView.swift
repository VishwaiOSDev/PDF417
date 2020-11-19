//
//  DisplayListView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI
import CodeScanner

struct DisplayListView: View {
    
    enum FilterType {
        case box , mail
    }
    
    let pasteBoard = UIPasteboard.general
    
    @State var copyToClipBoard : [String] = []
    
    @EnvironmentObject var displayLists : DisplayLists
    
    @State private var isShowingScanner = false
    
    @State var copyVariable : String = " "
    
    let filter : FilterType
    
    var title : String {
        switch filter{
        case .box:
            return "Box"
        case .mail:
            return  "Mail"
        }
    }
    
    var filterDisplayLists : [DisplayList]{
        switch filter{
        case .box:
            return displayLists.people.filter { $0.isContacted }
        case .mail:
            return displayLists.people.filter { !$0.isContacted }
        }
    }
    
    var body: some View {
        NavigationView{
            
            List{
                ForEach(filterDisplayLists){ displaylist in
                    VStack(alignment : .leading){
                        Text(displaylist.name)
                            .font(.headline)
                        Text(displaylist.email)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing: HStack{
                
                Button(action: {
                    
                    for items in displayLists.people{
                        let elements = "\(items.name) \(items.email)\n"
                        copyToClipBoard.append(elements)
                    }
                    
                    pasteBoard.strings = copyToClipBoard
                    
                }){
                    Text("Copy")
                }
                Button(action: {
                    self.isShowingScanner = true
                }) {
                    Image(systemName: "qrcode.viewfinder")
                }
                
                
            })
            
            .sheet(isPresented : $isShowingScanner){
                CodeScannerView(codeTypes: [.pdf417], simulatedData: "Vishwa|Appleismass|GoogleisWorst|Apple" , completion: self.handleScan)
            }
            
            
            
        }
        
        
    }
    
    func handleScan(result : Result<String , CodeScannerView.ScanError>){
        self.isShowingScanner = false
        
        switch result {
        case .success(let code):
            
            let details = code.components(separatedBy: "|")
            
            let avnString = String(details[5].dropFirst(4))
            let cityString = String(details[8].dropFirst(4))
            
            
            let data = DisplayList()
            data.name = avnString
            data.email = cityString
            self.displayLists.people.append(data)
            
            
            
        case .failure(let error):
            print("Failed \(error)")
            
        }
        
        
        
    }
    
}

struct DisplayListView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayListView(filter: .box)
    }
}
