//
//  AuthService.swift
//  FlowUs
//
//  Created by Lucas Goldner on 09.05.22.
//

import Firebase
import Foundation

class AuthService {
    @Published var user: User?
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    static let instance = AuthService()

    init() {
        addListeners()
    }

    private func addListeners() {
        if let handle = authenticationStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }

        authenticationStateHandler = Auth.auth()
            .addStateDidChangeListener { _, user in
                self.user = user
            }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
    }

    func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
    }
}
