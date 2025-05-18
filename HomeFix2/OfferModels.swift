//
//  OfferModels.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// OfferModels.swift

import SwiftUI
import Firebase

// Offer status enum
enum OfferStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case accepted = "Accepted"
    case inProgress = "In Progress"
    case completed = "Completed"
    case declined = "Declined"
    
    var color: Color {
        switch self {
        case .pending:
            return Color.orange
        case .accepted:
            return Color.blue
        case .inProgress:
            return Color.purple
        case .completed:
            return Color.green
        case .declined:
            return Color.red
        }
    }
}

// Offer model
struct Offer: Identifiable {
    var id: String
    var clientId: String
    var clientName: String
    var professionalId: String
    var jobDescription: String
    var address: String
    var date: Date
    var status: OfferStatus
    var createdAt: Date
    var category: String
    var price: Double?
    
    // Format date to readable string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Format price with currency
    var formattedPrice: String {
        guard let price = price else { return "Prix à déterminer" }
        return String(format: "%.2f DH", price)
    }
}
