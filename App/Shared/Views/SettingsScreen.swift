import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var userInfo: UserInfo
    @EnvironmentObject private var session: OtterLinkSession

    var body: some View {
        Form {
            Section("Account") {
                TextField("Username", text: $userInfo.username)
                    .textContentType(.username)
                    .onChange(of: userInfo.username) { _ in
                        userInfo.save()
                    }

                HStack {
                    Text("Local user ID")
                    Spacer()
                    Text(String(userInfo.userID.uuidString.prefix(8)))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }

            Section("OtterLink Server") {
                TextField("Server URL", text: $session.serverURL)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                Button {
                    session.rebuildAPI()
                    session.checkServer()
                } label: {
                    HStack {
                        Text("Test Connection")
                        Spacer()
                        if session.isCheckingServer {
                            ProgressView()
                        }
                    }
                }

                Label(
                    session.serverMessage,
                    systemImage: session.serverReachable ? "checkmark.circle" : "network"
                )
                .foregroundColor(session.serverReachable ? .green : .secondary)
                .font(.caption)
            }

            Section("Client") {
                Text("The iOS client uses the existing OtterLink HTTP API and will use the existing JSON-lines service for realtime messaging. Protocol details will be lifted from the Qt client rather than invented here.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Settings")
        .onDisappear {
            session.rebuildAPI()
        }
    }
}
