//
//  currency.swift
//  quote-currency
//
//  Created by Terence Dreico Borjal on 10/3/25.
//

import SwiftUI

struct CurrencyView: View {
        @State private var amount: String = ""
        @State private var fromCurrency: String = "USD"
        @State private var toCurrency: String = "EUR"
        @State private var convertedAmount: String = ""
        @State private var currencies: [String] = ["USD", "EUR"]
    
    var body: some View {
        VStack (spacing: 20) {
            
            Label("Welcome to the Currency Page", systemImage: "globe")
                .font(.title)
                .padding(.top, 40)
            Spacer()
            VStack(spacing: 16) {
            
            TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .border(Color.gray)
                        
                        HStack {
                            Picker("From", selection: $fromCurrency) {
                                ForEach(currencies, id: \.self) { currency in
                                    Text(currency)
                                }
                            }
                            Picker("To", selection: $toCurrency) {
                                ForEach(currencies, id: \.self) { currency in
                                    Text(currency)
                                }
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Button("Convert") {
                            convertCurrency()
                        }
                        .padding()
                        
                        Text("Converted Amount: \(convertedAmount)")
                            .font(.headline)
            }
            Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                    .onAppear {
                        fetchCurrencies()
                    }
    }
    func convertCurrency() {
        guard let amountValue = Double(amount) else {
            convertedAmount = "Invalid amount"
            return
        }
        let urlString = "https://api.frankfurter.app/latest?amount=\(amountValue)&from=\(fromCurrency)&to=\(toCurrency)"
        guard let url = URL(string: urlString) else { return }

        // Run on the main actor to satisfy main-actor isolated Decodable conformance in Swift 6
        Task { @MainActor in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                if let result = response.rates[toCurrency] {
                    convertedAmount = String(format: "%.2f", result)
                } else {
                    convertedAmount = "N/A"
                }
            } catch {
                convertedAmount = "Error"
            }
        }
    }

    func fetchCurrencies() {
        let urlString = "https://api.frankfurter.app/currencies"
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode([String: String].self, from: data)
                await MainActor.run {
                    currencies = Array(response.keys).sorted()
                }
            } catch {
                // You can handle errors here if desired
            }
        }
    }
}


struct CurrencyResponse: Codable {
    let rates: [String: Double]
}


struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}

