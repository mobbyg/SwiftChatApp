import Combine
import Foundation

final class UserInfo: ObservableObject {
    let userID: UUID

    @Published var username: String

    init() {
        if let savedID = UserDefaults.standard.string(forKey: "otterlink.userID"),
           let id = UUID(uuidString: savedID) {
            userID = id
        } else {
            userID = UUID()
            UserDefaults.standard.set(userID.uuidString, forKey: "otterlink.userID")
        }

        username = UserDefaults.standard.string(forKey: "otterlink.username") ?? ""
    }

    func save() {
        UserDefaults.standard.set(username, forKey: "otterlink.username")
    }
}
