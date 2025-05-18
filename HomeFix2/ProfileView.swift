import SwiftUI
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userProfile: UserProfile?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    if let profile = userProfile {
                        Text("Name: \(profile.name)")
                        Text("Email: \(profile.email)")
                        Text("Role: \(profile.role.capitalized)")
                        
                        if profile.role == "professional" {
                            Text("Profession: \(profile.profession)")
                            Text("Category: \(profile.category)")
                            Text("Hourly Rate: $\(profile.hourlyRate, specifier: "%.2f")")
                        }
                    } else {
                        Text("Loading profile...")
                    }
                }
                
                Section {
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("My Profile")
            .onAppear {
                loadUserProfile()
            }
        }
    }
    
    func loadUserProfile() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let role = data["role"] as? String ?? "client"
                let profession = data["profession"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let hourlyRate = data["hourlyRate"] as? Double ?? 0.0
                
                userProfile = UserProfile(
                    name: name,
                    email: email,
                    role: role,
                    profession: profession,
                    category: category,
                    hourlyRate: hourlyRate
                )
            }
        }
    }
}

struct UserProfile {
    var name: String
    var email: String
    var role: String
    var profession: String
    var category: String
    var hourlyRate: Double
}
