//
//  DisplayListView.swift
//  PDF417
//
//  Created by Vishweshwaran on 16/11/20.
//

import SwiftUI
import CoreData
import CodeScanner

enum ActiveSheet : Identifiable  {
    case first, second
    
    var id: Int {
        hashValue
    }
    
}

struct DisplayListView: View {
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items : FetchedResults<Item>
    @Environment(\.managedObjectContext) var moc

    enum FilterType {
        case box
    }
    
    var dataString = "V01~A01|D01~R3H0Z8|R01~RAINY CREEK POWERSPORTS LTD|R02~|R03~|R04~4845-50 AVENUE|R05~|R06~ECKVILLE|R07~T0M0X0|S01~FGT000220305|S02~FGT000220305|S03~0|S04~00|S05~0|S06~0|S07~5|S08~20201102|S09~1|S10~1|S11~13|S12~13|S13~95R|S14~|S15~DD|B01~260|B02~PP"
    
    
    @State var activeSheet: ActiveSheet?
    
    let pasteBoard = UIPasteboard.general
    
    @State private var textStreet : String = ""
    @State private var textPostalCode : String = ""
    
    @State var copyToClipBoard : [String] = []
    
    @State private var showingAlert = false
        
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
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                List{
                    
                    ForEach(items){ item in
                        
                        
                        HStack{
                            
                            Text(isToggle ? "M" : "B")
                                .font(.largeTitle)
                                .bold()
                                .padding(.trailing, 12)
                            
                            VStack(alignment : .leading){
                                Text("\(item.street!)")
                                    .font(.headline)
                                
                                Text("\(item.postalCode!)")
                                    .font(.subheadline)
                            }
                            
                        }
                        
                    }.onDelete(perform : performDelete)
                    .listStyle(PlainListStyle())
                    
                   
                    
                }
                .navigationBarTitle(title)
                .navigationBarItems(leading:
                                        HStack {
                                            //MARK: - Copy Button
                                            Button(action: {
                                                copyClips()
                                                self.showingAlert = true
                                            }) {
                                                Text("Copy")
                                                Image(systemName: "checkmark.circle")
                                            }.alert(isPresented:$showingAlert) {
                                                Alert(title: Text("Copied"), message: Text("List of items has been copied successfully."), dismissButton: .default(Text("Ok")))
                                            }
                                           
                                        }, trailing:
                                            HStack {
                                                
                                                Button(action : {
                                                    activeSheet = .second
                                                }){
                                                    Text("Add")
                                                    Image(systemName: "plus")
                                                    
                                                }
                                                
                                            }
                                            
                )
                .sheet(item : $activeSheet){ item in
                    switch item {
                    case .first:
                        CodeScannerView(codeTypes: [.pdf417], simulatedData: dataString, completion: self.handleScan)
                            .environment(\.managedObjectContext, self.moc)
                    case .second:
                        ManualAddressView(showModal: $activeSheet, addressFieldStreet : $textStreet, addressFieldPostalCode : $textPostalCode)
                            .environment(\.managedObjectContext, self.moc)

                    }
                    
                    
                }
                
                
                //MARK: - Mail Toggle Button
                Toggle(isOn: $isToggle){
                    Image(systemName: "mail.stack.fill")
                        .foregroundColor(.blue)
                    Text("Mail")
                        .foregroundColor(.blue)
                }.padding([.top,.leading,.trailing], 20)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                //MARK: - Scan Button
                LargeButton(title: "Scan",
                            image: "qrcode.viewfinder",
                            backgroundColor: Color.blue) {
                    activeSheet = .first
                }
                
            }
            
        }
        
    }
    
    
    //MARK: - Copy Function
    func copyClips(){
        copyToClipBoard.removeAll()
        
        for item in items{
            
            let elements = isToggle ? "\(item.street!) \(item.postalCode!) - (M)\n" : "\(item.street!) \(item.postalCode!) - (B)\n"
            copyToClipBoard.append(elements)
        }
        
        print(copyToClipBoard)
        pasteBoard.strings = copyToClipBoard
    }
    
    
    //MARK: - QRCode Scanner
    func handleScan(result : Result<String , CodeScannerView.ScanError>){
        activeSheet = nil
        switch result {
        case .success(let code):
            
            let details = code.components(separatedBy: "|")
            
            let avnString = String(details[5].dropFirst(4))
            let cityString = String(details[8].dropFirst(4))
            
            
            let item = Item(context: self.moc)
            item.street = "\(avnString)"
            item.postalCode = "\(cityString)"
            
            try? self.moc.save()
            
        case .failure(let error):
            print("Failed \(error)")
            
        }
        
    }
    
    //MARK: - Delete Function
    func performDelete(at offsets: IndexSet){
        for index in offsets{
            let item = items[index]
            moc.delete(item)
            
            try? self.moc.save()
        }
    }
    
}




//struct DisplayListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayListView(filter: .box).environmentObject()
//            .preferredColorScheme(.dark)
//    }
//}
