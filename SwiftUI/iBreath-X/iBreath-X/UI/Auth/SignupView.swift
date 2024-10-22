//
//  SignupView.swift
//  iBreath-X
//
//  Created by app on 2024/9/23.
//

import SwiftUI
import Supabase
struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    let supabase = SupabaseClient(supabaseURL: URL(string: "https://qtwujxiygwbxtklnsntj.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0d3VqeGl5Z3dieHRrbG5zbnRqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY2MjQxMTUsImV4cCI6MjA0MjIwMDExNX0.djmOjPi3_susj9g2YtkXMHMEqIMINWAdvsZhkHomJHY")
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    isRegistering ? register() : login()
                }) {
                    Text(isRegistering ? "Register" : "Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isRegistering.toggle()
                }) {
                    Text(isRegistering ? "Already have an account? Login" : "Don't have an account? Register")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationTitle(isRegistering ? "Register" : "Login")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }
    
    func register() {
        Task {
            do {
                let authResponse = try await supabase.auth.signUp(email: email, password: password)
                await MainActor.run {
                    alertMessage = "Registration successful. Please check your email to confirm your account."
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Registration failed: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    func login() {
        Task {
            do {
                let authResponse = try await supabase.auth.signIn(email: email, password: password)
                await MainActor.run {
                    alertMessage = "Login successful. Welcome, \(authResponse.user.email ?? "")!"
                    showAlert = true
                    // Here you would typically navigate to the main app view
                }
            } catch {
                await MainActor.run {
                    alertMessage = "Login failed: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
}

#Preview {
    SignupView()
}
