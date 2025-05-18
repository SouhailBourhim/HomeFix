//
//  OfferService.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 18/05/2025.
//

// OfferService.swift

import Firebase
import FirebaseFirestore

// Firebase service for offers
class OfferService {
    private let db = Firestore.firestore()
    private let offersCollection = "offers"
    
    // Get all offers for a professional
    func getOffersForProfessional(professionalId: String, completion: @escaping ([Offer]) -> Void) {
        db.collection(offersCollection)
            .whereField("professionalId", isEqualTo: professionalId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching offers: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let offers = documents.compactMap { document -> Offer? in
                    let data = document.data()
                    
                    guard let clientId = data["clientId"] as? String,
                          let clientName = data["clientName"] as? String,
                          let professionalId = data["professionalId"] as? String,
                          let jobDescription = data["jobDescription"] as? String,
                          let address = data["address"] as? String,
                          let dateTimestamp = data["date"] as? Timestamp,
                          let statusRaw = data["status"] as? String,
                          let status = OfferStatus(rawValue: statusRaw),
                          let createdTimestamp = data["createdAt"] as? Timestamp,
                          let category = data["category"] as? String else {
                        return nil
                    }
                    
                    let price = data["price"] as? Double
                    
                    return Offer(
                        id: document.documentID,
                        clientId: clientId,
                        clientName: clientName,
                        professionalId: professionalId,
                        jobDescription: jobDescription,
                        address: address,
                        date: dateTimestamp.dateValue(),
                        status: status,
                        createdAt: createdTimestamp.dateValue(),
                        category: category,
                        price: price
                    )
                }
                
                completion(offers)
            }
    }
    
    // Update offer status
    func updateOfferStatus(offerId: String, status: OfferStatus, completion: @escaping (Bool) -> Void) {
        db.collection(offersCollection).document(offerId).updateData([
            "status": status.rawValue
        ]) { error in
            if let error = error {
                print("Error updating offer status: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}
