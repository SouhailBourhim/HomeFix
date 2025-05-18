//
//  OfferDetailView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// OfferDetailView.swift

import SwiftUI

struct OfferDetailView: View {
    var offer: Offer
    @ObservedObject var viewModel: ProfessionalOffersViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingActionSheet = false
    @State private var isUpdating = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Client info card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Détails du Client")
                            .font(.headline)
                        
                        Spacer()
                        
                        OfferStatusBadge(status: offer.status)
                    }
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.indigo.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.indigo)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(offer.clientName)
                                .font(.system(size: 16, weight: .bold))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Call client action
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Job details card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Détails du Job")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        DetailRow(icon: "doc.text.fill", color: .blue, title: "Description", value: offer.jobDescription)
                        DetailRow(icon: "mappin.circle.fill", color: .red, title: "Adresse", value: offer.address)
                        DetailRow(icon: "calendar", color: .orange, title: "Date", value: offer.formattedDate)
                        DetailRow(icon: "tag.fill", color: .purple, title: "Catégorie", value: offer.category)
                        DetailRow(icon: "banknote", color: .green, title: "Prix", value: offer.formattedPrice)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                if offer.status == .pending {
                    HStack(spacing: 16) {
                        Button(action: {
                            updateOfferStatus(.declined)
                        }) {
                            Text("Refuser")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            updateOfferStatus(.accepted)
                        }) {
                            Text("Accepter")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                } else if offer.status == .accepted {
                    Button(action: {
                        updateOfferStatus(.inProgress)
                    }) {
                        Text("Commencer le travail")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else if offer.status == .inProgress {
                    Button(action: {
                        updateOfferStatus(.completed)
                    }) {
                        Text("Marquer comme terminé")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else if offer.status == .completed || offer.status == .declined {
                    Button(action: {
                        // Archive or hide functionality
                    }) {
                        Text("Archiver")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Détails de l'offre")
        .overlay(
            Group {
                if isUpdating {
                    ZStack {
                        Color.black.opacity(0.4)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        )
    }
    
    private func updateOfferStatus(_ status: OfferStatus) {
        isUpdating = true
        viewModel.updateOfferStatus(offer: offer, status: status)
        
        // Simulate delay for UI feedback, then go back
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isUpdating = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// For preview
struct OfferDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OfferDetailView(
                offer: Offer(
                    id: "1",
                    clientId: "client1",
                    clientName: "Mohammed Alami",
                    professionalId: "pro1",
                    jobDescription: "Installation électrique dans la cuisine",
                    address: "123 Rue Hassan II, Casablanca",
                    date: Date(),
                    status: .pending,
                    createdAt: Date(),
                    category: "Électricien",
                    price: 350
                ),
                viewModel: ProfessionalOffersViewModel(userId: "pro1")
            )
        }
    }
}
