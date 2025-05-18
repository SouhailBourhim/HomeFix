import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var role = "client" // Default role
    
    // Professional fields
    @State private var profession = ""
    @State private var category = ""
    @State private var hourlyRate = ""
    
    @State private var showProfessionalFields = false
    
    var roles = ["client", "professional"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Create Your Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Full Name", text: $name)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
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
                    
                    Picker("I am a:", selection: $role) {
                        ForEach(roles, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    // Cross-compatible onChange modifier
                    updateRolePickerView()
                }
                
                if showProfessionalFields {
                    VStack(spacing: 15) {
                        TextField("Profession (e.g., Electrician)", text: $profession)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        TextField("Category (e.g., Residential)", text: $category)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        TextField("Hourly Rate ($)", text: $hourlyRate)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    let rate = Double(hourlyRate) ?? 0.0
                    authViewModel.signUp(
                        email: email,
                        password: password,
                        name: name,
                        role: role,
                        profession: profession,
                        category: category,
                        hourlyRate: rate
                    )
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Already have an account? Login")
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    // Helper function to handle the role picker onChange event
    @ViewBuilder
    private func updateRolePickerView() -> some View {
        Group {
            if #available(iOS 17.0, *) {
                // New onChange syntax for iOS 17+
                Spacer().onChange(of: role) { oldValue, newValue in
                    showProfessionalFields = (newValue == "professional")
                }
            } else {
                // Legacy onChange syntax for iOS 16 and earlier
                Spacer().onChange(of: role) { newValue in
                    showProfessionalFields = (newValue == "professional")
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
