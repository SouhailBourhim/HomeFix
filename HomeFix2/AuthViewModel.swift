import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: FirebaseAuth.User?
    @Published var userRole: String = ""
    @Published var errorMessage = ""

    private var authStateHandler: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthListener()
    }

    deinit {
        removeAuthListener()
    }

    func setupAuthListener() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let user = user {
                self.isAuthenticated = true
                self.currentUser = user
                self.fetchUserRole()
            } else {
                self.isAuthenticated = false
                self.currentUser = nil
                self.userRole = ""
            }
        }
    }

    func removeAuthListener() {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
            authStateHandler = nil
        }
    }

    func fetchUserRole() {
        guard let userId = currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists, let data = document.data() {
                self?.userRole = data["role"] as? String ?? "client"
            } else {
                self?.userRole = "client"
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func signUp(email: String, password: String, name: String, role: String, profession: String = "", category: String = "", hourlyRate: Double = 0.0) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                return
            }

            guard let userId = result?.user.uid else { return }

            let db = Firestore.firestore()
            var userData: [String: Any] = [
                "name": name,
                "email": email,
                "role": role,
                "createdAt": Timestamp(date: Date())
            ]

            if role.lowercased() == "professional" {
                userData["profession"] = profession
                userData["category"] = category
                userData["hourlyRate"] = hourlyRate
            }

            db.collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
            userRole = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// MARK: - View Switching Extension

extension AuthViewModel {
    var isProfessional: Bool {
        return userRole.lowercased() == "professional"
    }

    @ViewBuilder
    func mainView() -> some View {
        if isProfessional {
            ProfessionalDashboardView()
                .environmentObject(self)
        } else {
            ContentView()
                .environmentObject(self)
        }
    }
}
