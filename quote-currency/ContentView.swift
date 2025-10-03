//
//  ContentView.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/2/25.
//
// Comments

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    
                    Image("earth-img")
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .padding(.all)
                    
                    Button("Generate Quote") {
                        path.append(Screen.quote)
                    }
                    
                    Button("Access Currency"){
                        path.append(Screen.currency)
                    }
                    
                    .navigationDestination(for: Screen.self) { screen in
                        switch screen {
                            
                        case .quote:
                            QuoteView()
                        case .currency:
                            CurrencyView()
                            
                        }
                    }
                }
            }
        }
    }
}

enum Screen: Hashable {
    case quote
    case currency
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

