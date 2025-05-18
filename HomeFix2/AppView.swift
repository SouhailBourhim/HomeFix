//
//  AppView.swift
//  HomeFix2
//
//  Created by Souhail Bourhim on 13/05/2025.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
