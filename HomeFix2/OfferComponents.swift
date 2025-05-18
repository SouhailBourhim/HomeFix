//
//  OfferComponents.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// OfferComponents.swift

import SwiftUI

// Status badge component
struct OfferStatusBadge: View {
    var status: OfferStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 12, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(12)
    }
}

// Offer row in the list
struct OfferRow: View {
    var offer: Offer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(offer.clientName)
                        .font(.headline)
                    
                    Text(offer.category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                OfferStatusBadge(status: offer.status)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                Text(offer.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text(offer.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "banknote")
                    .foregroundColor(.green)
                Text(offer.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

// Detail row component for offer details
struct DetailRow: View {
    var icon: String
    var color: Color
    var title: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16))
            }
        }
    }
}
