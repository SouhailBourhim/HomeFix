import SwiftUI



struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToRegister = false
    
    var body: some View {
       
        if #available(iOS 16.0, *) {
      
            NavigationStack {
                loginContent
                    .navigationDestination(isPresented: $navigateToRegister) {
                        RegisterView()
                    }
                    .navigationBarHidden(true)
            }
        } else {
            // iOS 15 approach
            NavigationView {
                loginContent
                    .navigationBarHidden(true)
                    .background(
                        NavigationLink(
                            destination: RegisterView(),
                            isActive: $navigateToRegister,
                            label: { EmptyView() }
                        )
                    )
            }
        }
    }
    
    // Shared content view
    private var loginContent: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Welcome to HomeFix")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            if !authViewModel.errorMessage.isEmpty {
                Text(authViewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                authViewModel.signIn(email: email, password: password)
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Button(action: {
                navigateToRegister = true
            }) {
                Text("Don't have an account? Register")
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
    }
}
