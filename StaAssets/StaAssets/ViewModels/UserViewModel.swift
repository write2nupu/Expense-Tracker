
import Foundation
import Combine

final class UserViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
}
