//
//  TextFieldClearButton.swift
//  PDF417
//
//  Created by Vishweshwaran on 21/11/20.
//

import SwiftUI

struct ClearButton: ViewModifier
{
    @Binding var text: String

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content

            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 24)
            }
        }
    }
}
