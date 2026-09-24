import SwiftUI

struct ChatScreen: View {
    @EnvironmentObject private var userInfo: UserInfo

    var body: some View {
        ContentPlaceholder(
            title: "Chat",
            icon: "bubble.left.and.bubble.right",
            message: "The tutorial WebSocket transport has been removed. This screen is now the native OtterLink chat destination, ready to be backed by the existing JSON-lines protocol."
        )
    }
}
