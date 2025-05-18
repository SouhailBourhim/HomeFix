//
//  ProfessionalOffersViewModel.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// ProfessionalOffersViewModel.swift

import SwiftUI

class ProfessionalOffersViewModel: ObservableObject {
    @Published var offers: [Offer] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let offerService = OfferService()
    private var userId: String
    
    init(userId: String) {
        self.userId = userId
        loadOffers()
    }
    
    func loadOffers() {
        isLoading = true
        
        offerService.getOffersForProfessional(professionalId: userId) { [weak self] offers in
            DispatchQueue.main.async {
                self?.offers = offers
                self?.isLoading = false
            }
        }
    }
    
    func updateOfferStatus(offer: Offer, status: OfferStatus) {
        isLoading = true
        
        offerService.updateOfferStatus(offerId: offer.id, status: status) { [weak self] success in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if !success {
                    self?.errorMessage = "Impossible de mettre à jour le statut de l'offre"
                }
            }
        }
    }
    
    // Filter offers by status
    func filteredOffers(status: OfferStatus?) -> [Offer] {
        guard let status = status else {
            return offers
        }
        return offers.filter { $0.status == status }
    }
}
