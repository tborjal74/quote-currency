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
        @State private var showAmountError = false
        @State private var amountErrorMessage = ""
        @State private var showFetchError = false
        @State private var fetchErrorMessage = ""
    
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
                    .alert(isPresented: $showAmountError) {
                        Alert(title: Text("Error"),
                              message: Text(amountErrorMessage),
                              dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showFetchError) {
                        Alert(title: Text("Error Loading Currencies"),
                              message: Text(fetchErrorMessage),
                              primaryButton: .default(Text("Retry"), action: { fetchCurrencies() }),
                              secondaryButton: .cancel())
                    }
    }
    func convertCurrency() {
        guard !amount.isEmpty else {
                amountErrorMessage = "Please enter an amount to convert."
                showAmountError = true
                return
            }
            guard let amountValue = Double(amount) else {
                amountErrorMessage = "Please enter a valid numeric amount."
                showAmountError = true
                return
            }
        
        let urlString = "https://api.frankfurter.app/latest?amount=\(amountValue)&from=\(fromCurrency)&to=\(toCurrency)"
        guard let url = URL(string: urlString) else { return }

        // Main Actor for the Currency Function
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
                await MainActor.run {
                    fetchErrorMessage = error.localizedDescription
                    showFetchError = true
                }
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

