//
//  FocusStateSample.swift
//  TestDemo
//
//  Created by app on 2024/8/21.
//

import SwiftUI

struct FocusStateSample: View {
    
    let textFieldBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var againPassword: String = ""
    @State private var email: String = ""
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20, content: {
                markTextField("Input your name", bindingName: $name, submitLabel: .next, keyboardTypeL: .default)
                markTextField("Input your password", bindingName: $password, submitLabel: .next, keyboardTypeL: .default)
                markTextField("Input your password again", bindingName: $againPassword, submitLabel: .next, keyboardTypeL: .default)
                markTextField("Input your email", bindingName: $email, submitLabel: .done, keyboardTypeL: .emailAddress)
                Button{
                    
                }label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.cornerRadius(10))
                }
                Spacer()
            }).padding().navigationTitle("Focus state").onTapGesture {
                dismissKeyboard()
            }
        }
    }
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func markTextField(
           _ prompt: String,
           bindingName: Binding<String>,
           submitLabel: SubmitLabel,
           keyboardTypeL: UIKeyboardType
       ) -> some View {
           TextField(prompt, text: bindingName)
               .font(.headline)
               .frame(height: 55)
               .submitLabel(submitLabel)
               .keyboardType(keyboardTypeL)
               .padding(.horizontal)
               .background(Color(uiColor: textFieldBackgroundColor))
               .cornerRadius(10)
    }
}



#Preview {
    FocusStateSample()
}
