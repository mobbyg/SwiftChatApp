import Combine
import Foundation

/// App-wide connection/session state.
///
/// Authentication is intentionally not invented here. The eventual login
/// flow should use the same server semantics as the existing OtterLink client.
final class OtterLinkSession: ObservableObject {
    @Published private(set) var isCheckingServer = false
    @Published private(set) var serverReachable = false
    @Published private(set) var serverMessage = "Not checked"

    var serverURL: String {
        didSet {
            UserDefaults.standard.set(serverURL, forKey: Self.serverURLKey)
        }
    }

    private(set) var api: OtterLinkAPI?

    private static let serverURLKey = "otterlink.serverURL"

    init() {
        serverURL = UserDefaults.standard.string(forKey: Self.serverURLKey)
            ?? "http://127.0.0.1:9090"
        rebuildAPI()
    }

    func rebuildAPI() {
        guard let url = URL(string: serverURL.trimmingCharacters(in: .whitespacesAndNewlines)),
              url.scheme != nil,
              url.host != nil else {
            api = nil
            return
        }

        api = OtterLinkAPI(baseURL: url)
    }

    func checkServer() {
        rebuildAPI()

        guard let api else {
            serverReachable = false
            serverMessage = "Invalid server URL"
            return
        }

        isCheckingServer = true
        serverMessage = "Checking…"

        api.health { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCheckingServer = false

                switch result {
                case .success:
                    self.serverReachable = true
                    self.serverMessage = "OtterLink server is reachable"
                case .failure(let error):
                    self.serverReachable = false
                    self.serverMessage = error.localizedDescription
                }
            }
        }
    }
}
