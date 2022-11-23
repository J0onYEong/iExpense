//
//  ExpenseItem.swift
//  iExpense
//
//  Created by 최준영 on 2022/11/20.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    var currencyType: CurrencyType
}

enum CurrencyType: String, Codable, CaseIterable {
    case korea = "WON"
    case usa = "USD"
    case japan = "JPY"
    
    var systemImage: String {
        switch self {
        case.korea: return "wonsign"
        case .usa: return "dollarsign"
        case .japan: return "yensign"
        }
    }
}

