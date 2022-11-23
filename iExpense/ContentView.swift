//
//  ContentView.swift
//  iExpense
//
//  Created by 최준영 on 2022/11/16.
//

import SwiftUI

class Expenses: ObservableObject {
    @Published var businessItems = [ExpenseItem]() {
        didSet {
            if let encodedData = try? JSONEncoder().encode(businessItems) {
                UserDefaults.standard.set(encodedData, forKey: "B_Items")
            }
        }
    }
    @Published var personalItems = [ExpenseItem]() {
        didSet {
            if let encodedData = try? JSONEncoder().encode(personalItems) {
                UserDefaults.standard.set(encodedData, forKey: "P_Items")
            }
        }
    }
    init() {
        if let encodedData = UserDefaults.standard.data(forKey: "B_Items") {
            if let decodedData = try? JSONDecoder().decode([ExpenseItem].self, from: encodedData) {
                businessItems = decodedData
                return;
            }
        }
        businessItems = []
        
        if let encodedData = UserDefaults.standard.data(forKey: "P_Items") {
            if let decodedData = try? JSONDecoder().decode([ExpenseItem].self, from: encodedData) {
                personalItems = decodedData
                return;
            }
        }
        personalItems = []
    }
}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Business Expenses") {
                    makeViewList(arr: expenses.businessItems, type: "Business")
                }
                Section("Personal Expenses") {
                    makeViewList(arr: expenses.personalItems, type: "Personal")
                }
            }

            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func makeViewList(arr: [ExpenseItem], type: String) -> some View {
        return ForEach(arr) {
            item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.type)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(item.amount, format: .currency(code: item.currencyType.rawValue))
                    .padding(.trailing, 5)
            }
        }
        .onDelete { (offsets: IndexSet) in
            type == "Business" ? expenses.businessItems.remove(atOffsets: offsets) : expenses.personalItems.remove(atOffsets: offsets)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
