//
//  MessagesView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 11/03/2025.
//

import SwiftUI

struct MessagesView: View {
    // État pour les conversations
    @State private var conversations = [
        Conversation(
            id: "1",
            professionalName: "Amine El Amrani",
            professionalImage: "person.fill",
            professionalCategory: "Électricien",
            lastMessage: "Bonjour, j'ai examiné les photos que vous m'avez envoyées. Je peux venir demain à 10h pour réparer le problème.",
            timestamp: Date().addingTimeInterval(-1800), // Il y a 30 minutes
            unreadCount: 2,
            isOnline: true
        ),
        Conversation(
            id: "2",
            professionalName: "Karim Benjelloun",
            professionalImage: "person.fill",
            professionalCategory: "Plombier",
            lastMessage: "D'accord, je confirme notre rendez-vous pour vendredi à 14h. N'hésitez pas si vous avez des questions d'ici là.",
            timestamp: Date().addingTimeInterval(-7200), // Il y a 2 heures
            unreadCount: 0,
            isOnline: false
        ),
        Conversation(
            id: "3",
            professionalName: "Hamid Tazi",
            professionalImage: "person.fill",
            professionalCategory: "Menuisier",
            lastMessage: "Merci pour votre paiement. J'espère que vous êtes satisfait du montage de vos meubles. N'hésitez pas à me contacter si besoin.",
            timestamp: Date().addingTimeInterval(-86400), // Il y a 1 jour
            unreadCount: 0,
            isOnline: true
        ),
        Conversation(
            id: "4",
            professionalName: "Younes Alami",
            professionalImage: "person.fill",
            professionalCategory: "Mécanicien",
            lastMessage: "Votre voiture est prête. Vous pouvez venir la récupérer quand vous voulez. Les freins sont comme neufs!",
            timestamp: Date().addingTimeInterval(-172800), // Il y a 2 jours
            unreadCount: 1,
            isOnline: false
        ),
        Conversation(
            id: "5",
            professionalName: "Omar El Fassi",
            professionalImage: "person.fill",
            professionalCategory: "Soudeur",
            lastMessage: "Je comprends. Pas de problème pour l'annulation. J'espère pouvoir vous aider une prochaine fois.",
            timestamp: Date().addingTimeInterval(-432000), // Il y a 5 jours
            unreadCount: 0,
            isOnline: false
        )
    ]
    
    // État pour la barre de recherche
    @State private var searchText = ""
    
    // Conversations filtrées selon la recherche
    var filteredConversations: [Conversation] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter {
                $0.professionalName.lowercased().contains(searchText.lowercased()) ||
                $0.professionalCategory.lowercased().contains(searchText.lowercased()) ||
                $0.lastMessage.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Barre de recherche avec bordure
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Rechercher dans les messages", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.indigo.opacity(0.3), lineWidth: 1)
                )
                .padding()
                
                // Liste des conversations
                if filteredConversations.isEmpty {
                    emptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredConversations) { conversation in
                                NavigationLink(destination: ChatDetailView(conversation: conversation)) {
                                    ConversationCard(conversation: conversation)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Messages")
            .background(Color(.systemGray6).ignoresSafeArea())
        }
    }
    
    // Vue pour état vide
    private func emptyStateView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.7))
                .padding()
            
            Text("Aucune conversation")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("Réservez un service et commencez à discuter avec des professionnels pour résoudre vos problèmes domestiques.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                // Action pour trouver un professionnel
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
        .frame(maxWidth: .infinity, minHeight: 400)
        .padding()
    }
}

// Carte de conversation
struct ConversationCard: View {
    var conversation: Conversation
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar du professionnel avec indicateur de statut en ligne
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: conversation.professionalImage)
                    .font(.system(size: 30))
                    .foregroundColor(.indigo)
                
                if conversation.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            
            // Informations de la conversation
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(conversation.professionalName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(timeAgo(conversation.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(conversation.professionalCategory)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.indigo.opacity(0.1))
                    .foregroundColor(.indigo)
                    .cornerRadius(4)
                
                Text(conversation.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 2)
            }
            
            // Indicateur de messages non lus
            if conversation.unreadCount > 0 {
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.indigo)
                            .frame(width: 22, height: 22)
                        
                        Text("\(conversation.unreadCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // Formatter le temps écoulé
    private func timeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "Hier" : "Il y a \(day) jours"
        } else if let hour = components.hour, hour > 0 {
            return "Il y a \(hour)h"
        } else if let minute = components.minute, minute > 0 {
            return "Il y a \(minute)min"
        } else {
            return "À l'instant"
        }
    }
}

// Vue détaillée de la conversation
struct ChatDetailView: View {
    var conversation: Conversation
    @State private var messageText = ""
    @State private var messages = [
        Message(id: "1", content: "Bonjour, j'ai un problème avec mon installation électrique.", isFromUser: true, timestamp: Date().addingTimeInterval(-3600)),
        Message(id: "2", content: "Bonjour, pouvez-vous me donner plus de détails ou m'envoyer des photos ?", isFromUser: false, timestamp: Date().addingTimeInterval(-3300)),
        Message(id: "3", content: "Bien sûr, voici quelques photos du problème. Les prises dans le salon ne fonctionnent plus depuis hier soir.", isFromUser: true, timestamp: Date().addingTimeInterval(-3000)),
        Message(id: "4", content: "Merci pour les photos. Il semble que ce soit un problème de disjoncteur. Avez-vous vérifié le tableau électrique ?", isFromUser: false, timestamp: Date().addingTimeInterval(-2700)),
        Message(id: "5", content: "Oui, j'ai vérifié et tout semble normal. Aucun disjoncteur n'a sauté.", isFromUser: true, timestamp: Date().addingTimeInterval(-2400)),
        Message(id: "6", content: "Bonjour, j'ai examiné les photos que vous m'avez envoyées. Je peux venir demain à 10h pour réparer le problème.", isFromUser: false, timestamp: Date().addingTimeInterval(-1800))
    ]
    
    var body: some View {
        VStack {
            // En-tête avec info du professionnel (déjà géré par la NavigationView)
            
            // Corps de la conversation
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Barre de saisie
            HStack {
                Button(action: {
                    // Action pour joindre un fichier
                }) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 8)
                
                TextField("Écrivez un message...", text: $messageText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: {
                    // Action pour envoyer un message
                    if !messageText.isEmpty {
                        let newMessage = Message(
                            id: UUID().uuidString,
                            content: messageText,
                            isFromUser: true,
                            timestamp: Date()
                        )
                        messages.append(newMessage)
                        messageText = ""
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.indigo)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
        }
        .navigationTitle(conversation.professionalName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: HStack(spacing: 16) {
                Button(action: {
                    // Action pour appeler
                }) {
                    Image(systemName: "phone")
                }
                
                Button(action: {
                    // Action pour accéder au profil
                }) {
                    Image(systemName: "info.circle")
                }
            }
        )
    }
}

// Bulle de message
struct MessageBubble: View {
    var message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                
                Text(message.content)
                    .padding(12)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .cornerRadius(4, corners: [.bottomRight])
                    .frame(maxWidth: 280, alignment: .trailing)
            } else {
                Text(message.content)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .foregroundColor(.primary)
                    .cornerRadius(18)
                    .cornerRadius(4, corners: [.bottomLeft])
                    .frame(maxWidth: 280, alignment: .leading)
                
                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

// Extension pour arrondir seulement certains coins
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Modèles de données
struct Conversation: Identifiable {
    var id: String
    var professionalName: String
    var professionalImage: String
    var professionalCategory: String
    var lastMessage: String
    var timestamp: Date
    var unreadCount: Int
    var isOnline: Bool
}

struct Message: Identifiable {
    var id: String
    var content: String
    var isFromUser: Bool
    var timestamp: Date
}

// Prévisualisation
struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
