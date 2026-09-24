import SwiftUI

struct ContentView: View {
    @StateObject private var userInfo = UserInfo()
    @StateObject private var session = OtterLinkSession()

    var body: some View {
        TabView {
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationView {
                PeopleScreen()
            }
            .tabItem {
                Label("People", systemImage: "person.2")
            }

            NavigationView {
                CommunitiesScreen()
            }
            .tabItem {
                Label("Communities", systemImage: "person.3")
            }

            NavigationView {
                ChatScreen()
            }
            .tabItem {
                Label("Chat", systemImage: "bubble.left.and.bubble.right")
            }

            NavigationView {
                SettingsScreen()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .environmentObject(userInfo)
        .environmentObject(session)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
