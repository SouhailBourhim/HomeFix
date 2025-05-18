import SwiftUI
import Firebase

@main
struct HomeFix2App: App {
    @StateObject var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                authViewModel.mainView()
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
