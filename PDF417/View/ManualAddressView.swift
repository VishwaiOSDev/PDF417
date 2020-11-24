//
//  ManualAddressView.swift
//  PDF417
//
//  Created by Vishweshwaran on 21/11/20.
//

import SwiftUI

struct ManualAddressView: View {
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items : FetchedResults<Item>
    @Environment(\.managedObjectContext) var moc
    
    @Binding var showModal : ActiveSheet?
    
    @Binding var addressFieldStreet : String
    @Binding var addressFieldPostalCode : String
    
    @State private var isShowError : Bool = false

    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Text(isShowError ? "Fields are Empty..." : "Add Fields Manually")
                    .font(.title)
                    .bold()
                    .padding(.all)
                
                Text("Instructions:\n\nTo add items to the list: \n1) Type the House number and street in First Field. \n2) Type only the Postal Code in Second Field.\n3) Both the Fields should not be Empty\n4) Click Done Button to Add items to List")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .padding(.all)
                    .foregroundColor(.secondary)

                TextField("Enter the Street...", text: $addressFieldStreet)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
                    .modifier(ClearButton(text: $addressFieldStreet))
                
                
                TextField("Enter the Postal Code...", text: $addressFieldPostalCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading , .trailing])
                    .modifier(ClearButton(text: $addressFieldPostalCode))
                
                
                LargeButton(title: "Done",
                            image: "checkmark.rectangle.fill",
                            backgroundColor: Color.blue) {
                    
                    if addressFieldStreet.isEmpty || addressFieldPostalCode.isEmpty {
                        self.isShowError = true
                    }
                    
                    else{
                        
                        let item = Item(context: self.moc)
                        item.street = "\(addressFieldStreet)"
                        item.postalCode = "\(addressFieldPostalCode)"
                        
                        try? self.moc.save()
                        
                        self.showModal = nil
                        
                    }
 
                }
            }
            .navigationTitle("Fields")
        }
        
    }
}

struct ManualAddressView_Previews: PreviewProvider {
    static var previews: some View {
        ManualAddressView(showModal: .constant(ActiveSheet.second), addressFieldStreet: .constant("Apple"), addressFieldPostalCode: .constant("Apple") )
            .preferredColorScheme(.dark)
    }
}
