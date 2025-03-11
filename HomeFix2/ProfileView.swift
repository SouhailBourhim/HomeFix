//
//  ProfileView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 11/03/2025.
//

//
//  Profile.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 11/03/2025.
//

//
//  ProfileView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 11/03/2025.
//

import SwiftUI

struct ProfileView: View {
    // États pour les données utilisateur
    @State private var user = User(
        id: "1",
        name: "Souhail Bourhim",
        email: "balesouhail@gmail.com",
        phone: "+212 6 16 19 00 15",
        address: "QUT CHARAF RES CHEMS IMM H NR 4 BENI MELLAL",
        profileImage: "person.crop.circle.fill",
        memberSince: Date(timeIntervalSince1970: 1741737600) 
    )
    
    // État pour le mode d'édition
    @State private var isEditingProfile = false
    @State private var editedName = ""
    @State private var editedEmail = ""
    @State private var editedPhone = ""
    @State private var editedAddress = ""
    
    // États pour les statistiques
    @State private var stats = [
        UserStat(id: "1", title: "Services réservés", value: "12", icon: "calendar.badge.clock", color: .blue),
        UserStat(id: "2", title: "Professionnels favoris", value: "5", icon: "star.fill", color: .yellow),
        UserStat(id: "3", title: "Économies réalisées", value: "1450 DH", icon: "banknote", color: .green)
    ]
    
    // État pour les options de préférences
    @State private var receiveNotifications = true
    @State private var darkModeEnabled = false
    @State private var allowLocationAccess = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Section profil utilisateur
                    profileHeaderSection()
                    
                    // Section statistiques
                    statsSection()
                    
                    // Section informations utilisateur
                    userInfoSection()
                    
                    // Section préférences
                    preferencesSection()
                    
                    // Section support et aide
                    supportSection()
                    
                    // Bouton déconnexion
                    Button(action: {
                        // Action pour se déconnecter
                    }) {
                        Text("Déconnexion")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Version de l'application
                    Text("HomeFix v1.0.0")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                }
            }
            .navigationTitle("Profil")
            .background(Color(.systemGray6).ignoresSafeArea())
            .sheet(isPresented: $isEditingProfile) {
                editProfileSheet()
            }
        }
    }
    
    // Section d'en-tête du profil
    private func profileHeaderSection() -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: user.profileImage)
                    .font(.system(size: 50))
                    .foregroundColor(.indigo)
            }
            
            Text(user.name)
                .font(.system(size: 24, weight: .bold))
            
            Text("Membre depuis \(formattedDate(user.memberSince))")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Button(action: {
                // Préparer l'édition du profil
                editedName = user.name
                editedEmail = user.email
                editedPhone = user.phone
                editedAddress = user.address
                isEditingProfile = true
            }) {
                Text("Modifier le profil")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.indigo)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.indigo.opacity(0.1))
                    .cornerRadius(20)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // Section des statistiques
    private func statsSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Vos statistiques")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)
            
            HStack(spacing: 12) {
                ForEach(stats) { stat in
                    statCard(stat)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Carte de statistique
    private func statCard(_ stat: UserStat) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(stat.color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: stat.icon)
                    .font(.system(size: 24))
                    .foregroundColor(stat.color)
            }
            
            Text(stat.value)
                .font(.system(size: 18, weight: .bold))
            
            Text(stat.title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    // Section des informations utilisateur
    private func userInfoSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Informations personnelles")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                infoRow(title: "Email", value: user.email, icon: "envelope.fill")
                Divider().padding(.leading, 50)
                infoRow(title: "Téléphone", value: user.phone, icon: "phone.fill")
                Divider().padding(.leading, 50)
                infoRow(title: "Adresse", value: user.address, icon: "location.fill")
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
    // Ligne d'information
    private func infoRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 34, height: 34)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.indigo)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 16))
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    // Section des préférences
    private func preferencesSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Préférences")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                toggleRow(title: "Notifications", isOn: $receiveNotifications, icon: "bell.fill")
                Divider().padding(.leading, 50)
                toggleRow(title: "Mode sombre", isOn: $darkModeEnabled, icon: "moon.fill")
                Divider().padding(.leading, 50)
                toggleRow(title: "Accès à la localisation", isOn: $allowLocationAccess, icon: "location.circle.fill")
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
    // Ligne avec toggle
    private func toggleRow(title: String, isOn: Binding<Bool>, icon: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.1))
                    .frame(width: 34, height: 34)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.indigo)
            }
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .indigo))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
    
    // Section support
    private func supportSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support & Aide")
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                navigationRow(title: "Centre d'aide", icon: "questionmark.circle.fill")
                Divider().padding(.leading, 50)
                navigationRow(title: "Contactez-nous", icon: "bubble.left.fill")
                Divider().padding(.leading, 50)
                navigationRow(title: "Conditions d'utilisation", icon: "doc.text.fill")
                Divider().padding(.leading, 50)
                navigationRow(title: "Politique de confidentialité", icon: "lock.shield.fill")
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
    
    // Ligne avec navigation
    private func navigationRow(title: String, icon: String) -> some View {
        Button(action: {
            // Action de navigation
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.1))
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.indigo)
                }
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
    }
    
    // Feuille d'édition du profil
    private func editProfileSheet() -> some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de base")) {
                    TextField("Nom complet", text: $editedName)
                    TextField("Email", text: $editedEmail)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $editedPhone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Adresse")) {
                    TextField("Adresse", text: $editedAddress)
                }
                
                Section {
                    Button(action: {
                        // Logique pour changer la photo de profil
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Changer la photo de profil")
                        }
                    }
                }
            }
            .navigationTitle("Modifier le profil")
            .navigationBarItems(
                leading: Button("Annuler") {
                    isEditingProfile = false
                },
                trailing: Button("Enregistrer") {
                    // Mettre à jour les informations utilisateur
                    user.name = editedName
                    user.email = editedEmail
                    user.phone = editedPhone
                    user.address = editedAddress
                    isEditingProfile = false
                }
            )
        }
    }
    
    // Formater la date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}

// Modèle de données pour l'utilisateur
struct User {
    var id: String
    var name: String
    var email: String
    var phone: String
    var address: String
    var profileImage: String
    var memberSince: Date
}

// Modèle de données pour les statistiques
struct UserStat: Identifiable {
    var id: String
    var title: String
    var value: String
    var icon: String
    var color: Color
}

// Prévisualisation
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
