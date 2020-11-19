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
        case box
    }
    
    let pasteBoard = UIPasteboard.general
    
    @State var copyToClipBoard : [String] = []
    
    @State private var showingAlert = false
    
    @EnvironmentObject var displayLists : DisplayLists
    
    @State private var isShowingScanner = false
    
    @State var copyVariable : String = " "
    
    @State private var isToggle = false
    
    let filter : FilterType
    
    var title : String {
        switch filter{
        case .box:
            return "Items"
        }
    }
    
    var filterDisplayLists : [DisplayList]{
        switch filter{
        case .box:
            return displayLists.people.filter { $0.isContacted }
            
        }
    }
    
    func delete(at offsets: IndexSet) {
        copyToClipBoard.remove(atOffsets: offsets)
        displayLists.people.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                List{
                    ForEach(filterDisplayLists){ displaylist in
                        
                        VStack(alignment : .leading){
                            
                            Text( isToggle ? "\(displaylist.name) - (M)" : "\(displaylist.name) - (B)")
                                .font(.headline)
                            
                            
                            Text(displaylist.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            
                        }
                    }
                    .onDelete(perform: delete)
                    .listStyle(PlainListStyle())
                    
                }
                .navigationBarTitle(title)
                .navigationBarItems(trailing:
                                        
                                        Button(action: {
                                            self.isShowingScanner = true
                                        }) {
                                            Image(systemName: "qrcode.viewfinder")
                                            Text("Scan")
                                        }
                                    
                                    
                )
                
                
                .sheet(isPresented : $isShowingScanner){
                    CodeScannerView(codeTypes: [.pdf417], simulatedData: "Vishwa|Appleismass|GoogleisWorst|Apple" , completion: self.handleScan)
                }
                
                Button(action:{
                    copyClips()
                    self.showingAlert = true
                }){
                    Image(systemName: "doc.on.clipboard")
                    Text("Copy")
                    
                    
                }.alert(isPresented:$showingAlert) {
                    Alert(title: Text("Copied"), message: Text("List of items has been copied successfully."), dismissButton: .default(Text("Ok")))
                }
                
                
                
                Toggle(isOn: $isToggle){
                    Image(systemName: "mail.stack.fill")
                        .foregroundColor(.blue)
                    Text("Mail")
                        .foregroundColor(.blue)
                }.padding(.all)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                
            }
        }
        
    }
    
    func copyClips(){
        copyToClipBoard.removeAll()
        
        for items in displayLists.people{
            let elements = isToggle ? "\(items.name) \(items.email) - (M)\n" : "\(items.name) \(items.email) - (B)\n"
            copyToClipBoard.append(elements)
        }
        
        print(copyToClipBoard)
        pasteBoard.strings = copyToClipBoard
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
