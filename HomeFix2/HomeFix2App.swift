import SwiftUI
import Firebase

@main
struct HomeFixApp: App {
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(authViewModel)
        }
    }
}
