//
//  ManualAddressView.swift
//  PDF417
//
//  Created by Vishweshwaran on 21/11/20.
//

import SwiftUI

struct ManualAddressView: View {
    
    @EnvironmentObject var displayLists : DisplayLists
    
    @Binding var showModal : ActiveSheet?
    
    @Binding var addressFieldStreet : String
    @Binding var addressFieldPostalCode : String
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Text("Add Fields Manually")
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
                        print("Fields are Empty you cannot add items")
                    }
                    
                    else{
                        
                        let data = DisplayList()
                        
                        data.street = addressFieldStreet
                        data.postalCode = addressFieldPostalCode
                        
                        self.displayLists.people.append(data)
                        
                        self.showModal = nil
                        
                    }
 
                }
            }
            .navigationTitle("Fields")
        }
        
    }
}

//struct ManualAddressView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualAddressView(showModal: .constant(), addressFieldStreet: .constant("Apple"), addressFieldPostalCode: .constant("Apple") )
//    }
//}
