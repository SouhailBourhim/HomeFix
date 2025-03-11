import SwiftUI

// Point d'entrée de l'application

// ContentView principal
struct ContentView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Label("Accueil", systemImage: "house.fill")
                }
            
            ReservationsView()
                .tabItem {
                    Label("Réservations", systemImage: "calendar")
                }
            
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .accentColor(.indigo)
    }
}

// Page d'accueil de l'application
struct HomePage: View {
    // État pour les catégories de services
    @State private var categories = [
        ServiceCategory(name: "Électricien", icon: "bolt.fill", color: Color(hex: "FF9500")),
        ServiceCategory(name: "Plombier", icon: "drop.fill", color: Color(hex: "0A84FF")),
        ServiceCategory(name: "Mécanicien", icon: "wrench.fill", color: Color(hex: "FF2D55")),
        ServiceCategory(name: "Menuisier", icon: "hammer.fill", color: Color(hex: "AF52DE")),
        ServiceCategory(name: "Soudeur", icon: "flame.fill", color: Color(hex: "FF3B30")),
        ServiceCategory(name: "Teinturier", icon: "paintbrush.fill", color: Color(hex: "FF9500")),
    ]
    
    // État pour la barre de recherche
    @State private var searchText = ""
    
    // État pour le filtre sélectionné
    @State private var selectedFilter = 0
    private let filters = ["Tous", "Populaires", "Bien notés", "Proximité"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Section de recherche
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Quel service recherchez-vous ?", text: $searchText)
                                .font(.system(size: 16, weight: .regular))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Filtres horizontaux
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<filters.count, id: \.self) { index in
                                    FilterChip(
                                        text: filters[index],
                                        isSelected: selectedFilter == index,
                                        action: { selectedFilter = index }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Section des services
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Services")
                            .font(.system(size: 24, weight: .bold))
                            .padding(.horizontal)
                        
                        // Grille de services
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(categories) { category in
                                NavigationLink(destination: ServiceListView(category: category)) {
                                    ModernCategoryCard(category: category)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Services urgents
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Services urgents")
                                .font(.system(size: 24, weight: .bold))
                            Spacer()
                            Button(action: {}) {
                                Text("Voir tout")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.indigo)
                            }
                        }
                        .padding(.horizontal)
                        
                        UrgentServiceBanner()
                            .padding(.horizontal)
                    }
                    
                    // Professionnels à proximité
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Pros à proximité")
                                .font(.system(size: 24, weight: .bold))
                            Spacer()
                            Button(action: {}) {
                                Text("Voir tout")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.indigo)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(1...5, id: \.self) { index in
                                    ModernProfessionalCard(
                                        name: "Amine El Amrani",
                                        profession: index % 2 == 0 ? "Électricien" : "Plombier",
                                        rating: 4.8,
                                        reviews: 128,
                                        price: "250 DH/h",
                                        imageUrl: "person.fill"
                                    )
                                    .frame(width: 280)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("HomeFix")
            .navigationBarItems(
                trailing: HStack(spacing: 16) {
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 36, height: 36)
                            Image(systemName: "bell")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 36, height: 36)
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.primary)
                        }
                    }
                }
            )
        }
    }
}

// Vue de la liste des services
struct ServiceListView: View {
    var category: ServiceCategory
    
    var body: some View {
        Text("Liste des \(category.name)s disponibles")
            .navigationTitle(category.name)
    }
}

// Carte de catégorie moderne
struct ModernCategoryCard: View {
    var category: ServiceCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(category.color.opacity(0.15))
                    .frame(height: 100)
                
                Image(systemName: category.icon)
                    .font(.system(size: 40))
                    .foregroundColor(category.color)
            }
            
            Text(category.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Chip de filtre
struct FilterChip: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.indigo : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// Bannière de service urgent
struct UrgentServiceBanner: View {
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "FF3B30").opacity(0.1))
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(Color(hex: "FF3B30"))
                        
                        Text("BESOIN URGENT ?")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "FF3B30"))
                    }
                    
                    Text("Trouvez un professionnel disponible immédiatement")
                        .font(.system(size: 16, weight: .medium))
                    
                    Button(action: {}) {
                        Text("Chercher maintenant")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "FF3B30"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.trailing, 16)
                
                Spacer()
                
                Image(systemName: "timer")
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: "FF3B30").opacity(0.7))
                    .padding(.trailing, 16)
            }
            .padding(16)
        }
    }
}

// Carte de professionnel moderne
struct ModernProfessionalCard: View {
    var name: String
    var profession: String
    var rating: Double
    var reviews: Int
    var price: String
    var imageUrl: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // En-tête avec photo et profession
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.indigo.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: imageUrl)
                        .font(.system(size: 24))
                        .foregroundColor(.indigo)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text(profession)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Badge de vérification
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.green)
                }
            }
            
            Divider()
            
            // Informations
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(price)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Tarif horaire")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(String(format: "%.1f", rating))
                            .font(.system(size: 16, weight: .bold))
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                    }
                    
                    Text("\(reviews) avis")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            // Boutons d'action
            HStack {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Appeler")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo)
                    .cornerRadius(8)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Réserver")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.indigo)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Extension pour les couleurs hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Modèle de données pour les catégories
struct ServiceCategory: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var color: Color
}

// Prévisualisation
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
