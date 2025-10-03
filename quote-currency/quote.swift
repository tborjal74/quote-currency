//
//  quote.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/3/25.
//

import SwiftUI

struct QuoteView: View {
    var body: some View {
        VStack{
            
            Label("Inspirational Quotes", systemImage: "pencil")
                .font(.title)
                .padding(.top, 40)
            Spacer()
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}
