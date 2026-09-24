import Foundation

/// Thin HTTP client for the existing OtterLink server API.
///
/// Keep this type independent of SwiftUI so the same transport can be reused
/// by Home, People, Communities, Events and messaging.
final class OtterLinkAPI {
    let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func get(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            completion(.failure(OtterLinkAPIError.invalidURL(path)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        session.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let http = response as? HTTPURLResponse else {
                completion(.failure(OtterLinkAPIError.invalidResponse))
                return
            }

            guard (200..<300).contains(http.statusCode) else {
                completion(.failure(OtterLinkAPIError.httpStatus(http.statusCode)))
                return
            }

            completion(.success(data ?? Data()))
        }.resume()
    }

    func health(completion: @escaping (Result<Data, Error>) -> Void) {
        get(path: "/api/health", completion: completion)
    }
}

enum OtterLinkAPIError: LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let path):
            return "Invalid OtterLink URL: \(path)"
        case .invalidResponse:
            return "The server returned an invalid response."
        case .httpStatus(let status):
            return "OtterLink returned HTTP \(status)."
        }
    }
}

/// Realtime transport is deliberately abstracted from the SwiftUI layer.
///
/// The native client should use the existing OtterLink JSON-lines service on
/// port 8023. The exact login/handshake/message envelopes belong here once
/// they are lifted directly from the Qt client/server implementation.
protocol OtterLinkRealtimeTransport: AnyObject {
    var isConnected: Bool { get }
    func connect()
    func disconnect()
}
