//
//  ManageServicesView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 14/05/2025.
//

import SwiftUI
import FirebaseFirestore

struct ManageServicesView: View {
    @State private var serviceOfferings: [ServiceOffering] = []
    @State private var showAddService = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if serviceOfferings.isEmpty {
                emptyStateView
            } else {
                servicesList
            }
            
            addServiceButton
        }
        .navigationTitle("My Services")
        .onAppear(perform: loadServices)
        .sheet(isPresented: $showAddService) {
            AddServiceView { newService in
                addService(newService)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Services")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("You haven't added any services yet. Tap the + button to add a service.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    private var servicesList: some View {
        List {
            ForEach(serviceOfferings) { service in
                VStack(alignment: .leading, spacing: 6) {
                    Text(service.name)
                        .font(.headline)
                    
                    Text(service.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    
                    Text("$\(service.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        deleteService(service)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
    
    private var addServiceButton: some View {
        Button(action: {
            showAddService = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add Service")
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func loadServices() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        
        Firestore.firestore().collection("users").document(userId)
            .collection("services").getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    errorMessage = "Error loading services: \(error.localizedDescription)"
                    return
                }
                
                if let documents = snapshot?.documents {
                    serviceOfferings = documents.compactMap { doc -> ServiceOffering? in
                        let data = doc.data()
                        return ServiceOffering(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            price: data["price"] as? Double ?? 0.0
                        )
                    }
                }
            }
    }
    
    private func addService(_ service: ServiceOffering) {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        let serviceData: [String: Any] = [
            "name": service.name,
            "description": service.description,
            "price": service.price
        ]
        
        Firestore.firestore().collection("users").document(userId)
            .collection("services").addDocument(data: serviceData) { error in
                if let error = error {
                    errorMessage = "Error adding service: \(error.localizedDescription)"
                } else {
                    showAddService = false
                    loadServices()
                }
            }
    }
    
    private func deleteService(_ service: ServiceOffering) {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("services").document(service.id).delete { error in
                if let error = error {
                    errorMessage = "Error deleting service: \(error.localizedDescription)"
                } else {
                    loadServices()
                }
            }
    }
}

struct ManageServicesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ManageServicesView()
                .environmentObject(AuthViewModel())
        }
    }
}
