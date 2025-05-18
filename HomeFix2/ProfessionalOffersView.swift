//
//  ProfessionalOffersView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// ProfessionalOffersView.swift

import SwiftUI

struct ProfessionalOffersView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ProfessionalOffersViewModel
    @State private var selectedTab: OfferStatus?
    @State private var showingErrorAlert = false
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ProfessionalOffersViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(
                            text: "Tous",
                            isSelected: selectedTab == nil,
                            action: { selectedTab = nil }
                        )
                        
                        ForEach(OfferStatus.allCases, id: \.self) { status in
                            FilterChip(
                                text: status.rawValue,
                                isSelected: selectedTab == status,
                                action: { selectedTab = status }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.filteredOffers(status: selectedTab).isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("Aucune offre disponible")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("Les nouvelles offres apparaîtront ici")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredOffers(status: selectedTab)) { offer in
                            NavigationLink(destination: OfferDetailView(offer: offer, viewModel: viewModel)) {
                                OfferRow(offer: offer)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .refreshable {
                        viewModel.loadOffers()
                    }
                }
            }
            .navigationTitle("Mes Offres")
            .navigationBarItems(
                trailing: Button(action: {
                    viewModel.loadOffers()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            )
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("Erreur"),
                    message: Text(viewModel.errorMessage ?? "Une erreur s'est produite"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: viewModel.errorMessage) { newValue in
                    showingErrorAlert = newValue != nil
            }

        }
    }
}

// For preview
struct ProfessionalOffersView_Previews: PreviewProvider {
    static var previews: some View {
        ProfessionalOffersView(userId: "test-user")
            .environmentObject(AuthViewModel())
    }
}
