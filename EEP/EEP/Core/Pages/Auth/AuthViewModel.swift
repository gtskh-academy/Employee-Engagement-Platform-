import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    init() {
        checkAuthenticationState()
    }
    
    func checkAuthenticationState() {
        isAuthenticated = TokenManager.shared.isTokenValid
        currentUser = TokenManager.shared.currentUser
    }
    
    func logout() {
        TokenManager.shared.clear()
        isAuthenticated = false
        currentUser = nil
    }
}
