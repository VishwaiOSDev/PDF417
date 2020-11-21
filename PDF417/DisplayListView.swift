//
//  DisplayListView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI
import CodeScanner

enum ActiveSheet  {
    case first, second
}

struct DisplayListView: View {
    
    enum FilterType {
        case box
    }
    
    @State private var activeSheet: ActiveSheet?
    
    @State private var showSheet = false
    
    let pasteBoard = UIPasteboard.general
    
    @State private var textStreet : String = ""
    @State private var textPostalCode : String = ""
    
    @State var copyToClipBoard : [String] = []
    
    @State private var showingAlert = false
    
    @EnvironmentObject var displayLists : DisplayLists
    
    @State private var isShowingManualAddress = false
    
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
                            
                            Text( isToggle ? "\(displaylist.street) - (M)" : "\(displaylist.street) - (B)")
                                .font(.headline)
                            
                            Text(displaylist.postalCode)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                        }
                        
                    }
                    .onDelete(perform : delete)
                    .listStyle(PlainListStyle())
                    
                }
                .navigationBarTitle(title)
                .navigationBarItems(trailing:
                                        HStack {
                                            
                                            //MARK: - Copy Button
                                            Button(action: {
                                                copyClips()
                                                self.showingAlert = true
                                            }) {
                                                Text("Copy")
                                            }.alert(isPresented:$showingAlert) {
                                                Alert(title: Text("Copied"), message: Text("List of items has been copied successfully."), dismissButton: .default(Text("Ok")))
                                            }
                                            
                                            //MARK: - New item Button
                                            Button(action : {
                                                self.showSheet = true
                                                
                                                activeSheet = .second
                                                
                                                
                                            }){
                                                Image(systemName: "plus")
                                            }
                                            
                                        }
                ).sheet(isPresented : $showSheet) {
                    if self.activeSheet == .first{
                        CodeScannerView(codeTypes: [.pdf417], simulatedData: "Vishwa|Appleismass|GoogleisWorst|Apple" , completion: self.handleScan)
                    }
                    if self.activeSheet == .second{
                        ManualAddressView(showModal: $showSheet, addressFieldStreet : $textStreet, addressFieldPostalCode : $textPostalCode)                    }
                }
                
                //MARK: - Mail Toggle Button
                Toggle(isOn: $isToggle){
                    Image(systemName: "mail.stack.fill")
                        .foregroundColor(.blue)
                    Text("Mail")
                        .foregroundColor(.blue)
                }.padding([.top,.leading,.trailing])
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                //MARK: - Scan Button
                LargeButton(title: "Scan",
                            image: "qrcode.viewfinder",
                            backgroundColor: Color.blue) {
                    self.showSheet = true

                    activeSheet = .first
                }
                
            }
        }
        
    }
    
    
    //MARK: - Copy Function
    func copyClips(){
        copyToClipBoard.removeAll()
        
        for items in displayLists.people{
            let elements = isToggle ? "\(items.street) \(items.postalCode) - (M)\n" : "\(items.street) \(items.postalCode) - (B)\n"
            copyToClipBoard.append(elements)
        }
        
        print(copyToClipBoard)
        pasteBoard.strings = copyToClipBoard
    }
    
    
    //MARK: - QRCode Scanner
    func handleScan(result : Result<String , CodeScannerView.ScanError>){
        self.showSheet = false
        switch result {
        case .success(let code):
            
            let details = code.components(separatedBy: "|")
            
            let avnString = String(details[5].dropFirst(4))
            let cityString = String(details[8].dropFirst(4))
            
            
            let data = DisplayList()
            data.street = avnString
            data.postalCode = cityString
            self.displayLists.people.append(data)
            
        case .failure(let error):
            print("Failed \(error)")
            
        }
        
    }
    
}

struct DisplayListView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayListView(filter: .box).environmentObject(DisplayLists())
            .preferredColorScheme(.dark)
    }
}
