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
                    Text("Quote | Currency App")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                    
                    Label("Welcome!", systemImage: "star")
                        .padding(.top, 20)

                    Spacer()
                    
                    VStack {
                        Image("earth-img")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 450)
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .padding(.top, 50)
                        
                        Button("Browse Quotes") {
                            path.append(Screen.quote)
                        }
                        .padding(25)
                        
                        Button("Use Currency Converter"){
                            path.append(Screen.currency)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        
                        Button("Collection") {
                            path.append(Screen.collection)
                        }
                        .padding(25)
                    }
                    Spacer()
                    
                    .navigationDestination(for: Screen.self) { screen in
                        switch screen {
                            
                        case .quote:
                            QuoteView()
                        case .currency:
                            CurrencyView()
                        case .collection:
                            CollectionView()
                            
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
    case collection
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

