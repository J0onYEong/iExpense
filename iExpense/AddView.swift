//
//  AddView.swift
//  iExpense
//
//  Created by 최준영 on 2022/11/21.
//

import SwiftUI

struct AddView: View {
    
    enum ExpenseType: String, CaseIterable {
        case Business = "Business"
        case Personal = "Personal"
    }
    
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    @State var type = ExpenseType.Personal
    @State var amount = ""
    @State var currencyType: CurrencyType = .usa
    @FocusState private var isKeyboardFocused
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Product name", text: $name)
                    .textInputAutocapitalization(.never)
                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases, id: \.self) {
                        type in
                        Text(type.rawValue)
                    }
                }
                HStack{
                    Picker(selection: $currencyType, label: Text("")) {
                        ForEach(CurrencyType.allCases, id: \.self) {
                            code in
                            Image(systemName: code.systemImage)
                        }
                    }
                    .padding(.trailing, 10)
                    .frame(width: 45)
                    .clipped()
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .focused($isKeyboardFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                if isKeyboardFocused {
                                    Spacer()
                                    Button("Return") {
                                        isKeyboardFocused = false
                                    }
                                }
                            }
                        }
                    Spacer()
                }
            }
            .toolbar {
                HStack {
                    Button("Add") {
                        switch type {
                        case .Business:
                            expenses.businessItems.append(ExpenseItem(name: name, type: type.rawValue, amount: Double(amount) ?? 0.0, currencyType: currencyType))
                        case .Personal:
                            expenses.personalItems.append(ExpenseItem(name: name, type: type.rawValue, amount: Double(amount) ?? 0.0, currencyType: currencyType))
                        }
                        name = ""
                        type = .Personal
                        amount = ""
                    }
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add new expense")
        }
    }
}
