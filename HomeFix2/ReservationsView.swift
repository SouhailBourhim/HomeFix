//
//  ReservationsView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 11/03/2025.
//

import SwiftUI

struct ReservationsView: View {
    // État pour suivre le segment sélectionné
    @State private var selectedTab = 0
    
    // État pour les réservations
    @State private var reservations = [
        Reservation(
            id: "1",
            serviceName: "Réparation électrique",
            professionalName: "Amine El Amrani",
            professionalImage: "person.fill",
            professionalCategory: "Électricien",
            status: .upcoming,
            date: Date().addingTimeInterval(86400), // Demain
            time: "10:00 - 12:00",
            address: "12 Rue Mohammed V, Casablanca",
            price: "250 DH"
        ),
        Reservation(
            id: "2",
            serviceName: "Fuite d'eau salle de bain",
            professionalName: "Karim Benjelloun",
            professionalImage: "person.fill",
            professionalCategory: "Plombier",
            status: .upcoming,
            date: Date().addingTimeInterval(259200), // Dans 3 jours
            time: "14:00 - 16:00",
            address: "45 Avenue Hassan II, Casablanca",
            price: "350 DH"
        ),
        Reservation(
            id: "3",
            serviceName: "Installation meuble IKEA",
            professionalName: "Hamid Tazi",
            professionalImage: "person.fill",
            professionalCategory: "Menuisier",
            status: .completed,
            date: Date().addingTimeInterval(-172800), // Il y a 2 jours
            time: "09:00 - 11:30",
            address: "8 Rue des Orangers, Casablanca",
            price: "180 DH"
        ),
        Reservation(
            id: "4",
            serviceName: "Remplacement disques de frein",
            professionalName: "Younes Alami",
            professionalImage: "person.fill",
            professionalCategory: "Mécanicien",
            status: .completed,
            date: Date().addingTimeInterval(-604800), // Il y a 7 jours
            time: "11:00 - 13:00",
            address: "22 Boulevard Anfa, Casablanca",
            price: "550 DH"
        ),
        Reservation(
            id: "5",
            serviceName: "Réparation grille métallique",
            professionalName: "Omar El Fassi",
            professionalImage: "person.fill",
            professionalCategory: "Soudeur",
            status: .cancelled,
            date: Date().addingTimeInterval(-86400), // Hier
            time: "16:00 - 18:00",
            address: "5 Rue Ibn Toumart, Casablanca",
            price: "300 DH"
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segments pour filtrer les réservations
                Picker("Réservations", selection: $selectedTab) {
                    Text("À venir").tag(0)
                    Text("Terminées").tag(1)
                    Text("Annulées").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Conteneur principal
                ScrollView {
                    VStack(spacing: 16) {
                        // Filtrage des réservations selon le segment sélectionné
                        let filteredReservations = filterReservations(for: selectedTab)
                        
                        if filteredReservations.isEmpty {
                            emptyStateView(for: selectedTab)
                        } else {
                            ForEach(filteredReservations) { reservation in
                                ReservationCard(reservation: reservation)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Mes réservations")
            .background(Color(.systemGray6).ignoresSafeArea())
        }
    }
    
    // Fonction pour filtrer les réservations selon le segment
    private func filterReservations(for tab: Int) -> [Reservation] {
        switch tab {
        case 0:
            return reservations.filter { $0.status == .upcoming }
        case 1:
            return reservations.filter { $0.status == .completed }
        case 2:
            return reservations.filter { $0.status == .cancelled }
        default:
            return reservations
        }
    }
    
    // Vue pour état vide
    private func emptyStateView(for tab: Int) -> some View {
        VStack(spacing: 20) {
            Image(systemName: getEmptyStateIcon(for: tab))
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.7))
                .padding()
            
            Text(getEmptyStateMessage(for: tab))
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(getEmptyStateDescription(for: tab))
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            if tab == 0 {
                Button(action: {
                    // Action pour réserver
                }) {
                    Text("Trouver un professionnel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
                        .background(Color.indigo)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 400)
        .padding()
    }
    
    // Icône pour l'état vide selon le segment
    private func getEmptyStateIcon(for tab: Int) -> String {
        switch tab {
        case 0:
            return "calendar.badge.plus"
        case 1:
            return "checkmark.circle"
        case 2:
            return "xmark.circle"
        default:
            return "calendar"
        }
    }
    
    // Message principal pour l'état vide
    private func getEmptyStateMessage(for tab: Int) -> String {
        switch tab {
        case 0:
            return "Aucune réservation à venir"
        case 1:
            return "Aucun service terminé"
        case 2:
            return "Aucune réservation annulée"
        default:
            return "Aucune réservation"
        }
    }
    
    // Description pour l'état vide
    private func getEmptyStateDescription(for tab: Int) -> String {
        switch tab {
        case 0:
            return "Vous n'avez pas encore réservé de service. Trouvez un professionnel pour résoudre vos problèmes domestiques."
        case 1:
            return "Quand vos réservations seront terminées, elles apparaîtront ici."
        case 2:
            return "Les réservations que vous annulez apparaîtront ici. Nous espérons que vous n'en aurez pas besoin !"
        default:
            return "Réservez votre premier service avec un professionnel qualifié."
        }
    }
}

// Carte de réservation
struct ReservationCard: View {
    var reservation: Reservation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // En-tête
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: reservation.professionalImage)
                        .font(.system(size: 24))
                        .foregroundColor(.indigo)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(reservation.serviceName)
                        .font(.headline)
                    
                    Text(reservation.professionalName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(reservation.professionalCategory)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.indigo.opacity(0.1))
                        .foregroundColor(.indigo)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Badge de statut
                StatusBadge(status: reservation.status)
            }
            .padding()
            
            Divider()
            
            // Détails de la réservation
            VStack(spacing: 12) {
                // Date et heure
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                        .frame(width: 24)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading) {
                        Text(formattedDate(reservation.date))
                            .font(.subheadline)
                        
                        Text(reservation.time)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(reservation.price)
                        .font(.headline)
                        .foregroundColor(.indigo)
                }
                
                // Adresse
                HStack(alignment: .top) {
                    Image(systemName: "location")
                        .frame(width: 24)
                        .foregroundColor(.gray)
                    
                    Text(reservation.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Spacer()
                }
            }
            .padding()
            
            // Boutons d'action (uniquement pour les réservations à venir)
            if reservation.status == .upcoming {
                Divider()
                
                HStack {
                    Button(action: {
                        // Action pour contacter
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Contacter")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.indigo)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.indigo, lineWidth: 1)
                        )
                    }
                    
                    Button(action: {
                        // Action pour annuler
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Annuler")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            // Bouton d'évaluation (uniquement pour les réservations terminées qui n'ont pas encore été évaluées)
            if reservation.status == .completed && !reservation.isRated {
                Divider()
                
                Button(action: {
                    // Action pour évaluer
                }) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Évaluer ce service")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // Formatter la date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

// Badge de statut
struct StatusBadge: View {
    var status: ReservationStatus
    
    var body: some View {
        Text(status.displayText)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.1))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

// Modèle de données
struct Reservation: Identifiable {
    var id: String
    var serviceName: String
    var professionalName: String
    var professionalImage: String
    var professionalCategory: String
    var status: ReservationStatus
    var date: Date
    var time: String
    var address: String
    var price: String
    var isRated: Bool = false
}

// Statut de réservation
enum ReservationStatus {
    case upcoming
    case completed
    case cancelled
    
    var displayText: String {
        switch self {
        case .upcoming:
            return "À venir"
        case .completed:
            return "Terminé"
        case .cancelled:
            return "Annulé"
        }
    }
    
    var color: Color {
        switch self {
        case .upcoming:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

// Prévisualisation
struct ReservationsView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationsView()
    }
}
