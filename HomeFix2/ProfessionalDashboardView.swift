//
//  ProfessionalDashboardView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 14/05/2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfessionalDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var serviceOfferings: [ServiceOffering] = []
    @State private var appointments: [Appointment] = []
    @State private var selectedTab = 0
    @State private var showAddService = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header area
                VStack(alignment: .leading, spacing: 10) {
                    Text("Professional Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Manage your services and appointments")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Divider()
                }
                .padding()
                
                // Tab selector
                HStack(spacing: 0) {
                    tabButton(title: "Services", index: 0)
                    tabButton(title: "Appointments", index: 1)
                    tabButton(title: "Statistics", index: 2)
                }
                .padding(.horizontal)
                
                // Content area
                TabView(selection: $selectedTab) {
                    // Services Tab
                    servicesTab
                        .tag(0)
                    
                    // Appointments Tab
                    appointmentsTab
                        .tag(1)
                    
                    // Statistics Tab
                    statisticsTab
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                authViewModel.signOut()
            }) {
                Text("Se déconnecter")
                    .foregroundColor(.red)
            })
            .onAppear {
                loadData()
            }
            .sheet(isPresented: $showAddService) {
                AddServiceView { newService in
                    addService(newService)
                    showAddService = false
                }
            }
        }
    }
    
    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = index
            }
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .fontWeight(selectedTab == index ? .bold : .regular)
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                
                // Indicator line
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(selectedTab == index ? .blue : .clear)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    
    // MARK: - Services Tab
    private var servicesTab: some View {
        VStack {
            if serviceOfferings.isEmpty {
                emptyStateView(
                    systemImage: "wrench.and.screwdriver",
                    title: "Pas de service",
                    message: "Vous n'avez pas encore ajouter de service . appuyer sur + pour ajouter un."
                )
            } else {
                List {
                    ForEach(serviceOfferings) { service in
                        ServiceRowView(service: service)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteService(service)
                                } label: {
                                    Label("Suprimmer", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            
            Button(action: {
                showAddService = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Ajouter un service")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
    }
    
    // MARK: - Appointments Tab
    private var appointmentsTab: some View {
        VStack {
            if appointments.isEmpty {
                emptyStateView(
                    systemImage: "calendrier",
                    title: "pas de rendez-vous",
                    message: "Vous n'avez pas encore de rendez-vous. Ils apparaîtront ici lorsque les clients réserveront vos services."
                )
            } else {
                List {
                    ForEach(appointments) { appointment in
                        AppointmentRowView(appointment: appointment)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    cancelAppointment(appointment)
                                } label: {
                                    Label("Cancel", systemImage: "xmark.circle")
                                }
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Statistics Tab
    private var statisticsTab: some View {
        VStack {
            emptyStateView(
                systemImage: "chart.bar",
                title: "Statistiques à venir",
                message: "Nous travaillons à fournir des informations sur les performances de votre entreprise."
            )
        }
    }
    
    // MARK: - Empty State View
    private func emptyStateView(systemImage: String, title: String, message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 60)
    }
    
    // MARK: - Data Loading Functions
    private func loadData() {
        isLoading = true
        errorMessage = ""
        
        loadServices()
        loadAppointments()
        
        isLoading = false
    }
    
    private func loadServices() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("services").getDocuments { snapshot, error in
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
    
    private func loadAppointments() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("appointments").getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "Error loading appointments: \(error.localizedDescription)"
                    return
                }
                
                if let documents = snapshot?.documents {
                    appointments = documents.compactMap { doc -> Appointment? in
                        let data = doc.data()
                        return Appointment(
                            id: doc.documentID,
                            clientId: data["clientId"] as? String ?? "",
                            clientName: data["clientName"] as? String ?? "",
                            serviceId: data["serviceId"] as? String ?? "",
                            serviceName: data["serviceName"] as? String ?? "",
                            date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                            status: data["status"] as? String ?? "pending"
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
    
    private func cancelAppointment(_ appointment: Appointment) {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("appointments").document(appointment.id).updateData([
                "status": "cancelled"
            ]) { error in
                if let error = error {
                    errorMessage = "Error cancelling appointment: \(error.localizedDescription)"
                } else {
                    loadAppointments()
                }
            }
    }
}

// MARK: - Support Views
struct ServiceRowView: View {
    let service: ServiceOffering
    
    var body: some View {
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
    }
}

struct AppointmentRowView: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(appointment.clientName)
                .font(.headline)
            
            Text(appointment.serviceName)
                .font(.subheadline)
            
            Text(formatDate(appointment.date))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text(appointment.status.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(appointment.status))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "pending":
            return .orange
        case "confirmed":
            return .green
        case "cancelled":
            return .red
        default:
            return .gray
        }
    }
}

// MARK: - Models
struct ServiceOffering: Identifiable {
    var id: String
    var name: String
    var description: String
    var price: Double
}

struct Appointment: Identifiable {
    var id: String
    var clientId: String
    var clientName: String
    var serviceId: String
    var serviceName: String
    var date: Date
    var status: String
}

struct AddServiceView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    
    var onAdd: (ServiceOffering) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Service Details")) {
                    TextField("Service Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Price ($)", text: $price)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Service")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let servicePrice = Double(price) ?? 0.0
                    let newService = ServiceOffering(
                        id: UUID().uuidString,
                        name: name,
                        description: description,
                        price: servicePrice
                    )
                    onAdd(newService)
                }
                .disabled(name.isEmpty || price.isEmpty)
            )
        }
    }
}

struct ProfessionalDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ProfessionalDashboardView()
            .environmentObject(AuthViewModel())
    }
}
