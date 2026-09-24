import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var session: OtterLinkSession

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("OtterLink")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Your community, conversations and services.")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Connection") {
                HStack {
                    Circle()
                        .fill(session.serverReachable ? Color.green : Color.secondary)
                        .frame(width: 10, height: 10)

                    VStack(alignment: .leading) {
                        Text(session.serverReachable ? "Connected" : "Not connected")
                            .fontWeight(.medium)
                        Text(session.serverMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    if session.isCheckingServer {
                        ProgressView()
                    } else {
                        Button("Check") {
                            session.checkServer()
                        }
                    }
                }
            }

            Section("Coming together") {
                NavigationLink(destination: PeopleScreen()) {
                    Label("People", systemImage: "person.2")
                }

                NavigationLink(destination: CommunitiesScreen()) {
                    Label("Communities", systemImage: "person.3")
                }

                NavigationLink(destination: ChatScreen()) {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right")
                }

                NavigationLink(destination: EventsScreen()) {
                    Label("Events", systemImage: "calendar")
                }
            }
        }
        .navigationTitle("Home")
    }
}

struct PeopleScreen: View {
    var body: some View {
        ContentPlaceholder(
            title: "People",
            icon: "person.2",
            message: "This is the native iOS destination for the OtterLink People service."
        )
    }
}

struct CommunitiesScreen: View {
    var body: some View {
        ContentPlaceholder(
            title: "Communities",
            icon: "person.3",
            message: "Communities will be populated from the existing OtterLink API."
        )
    }
}

struct EventsScreen: View {
    var body: some View {
        ContentPlaceholder(
            title: "Events",
            icon: "calendar",
            message: "Events will use the existing OtterLink event API and rules."
        )
    }
}

struct ContentPlaceholder: View {
    let title: String
    let icon: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundColor(.accentColor)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(title)
        .padding()
    }
}
