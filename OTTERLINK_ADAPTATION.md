# OtterLink adaptation notes

This fork is a tutorial-first SwiftUI/WebSocket chat implementation. The useful part for OtterLink is the small SwiftUI client pattern and the separation between the message model, transport, and views.

## Direction

Keep SwiftUI as the UI layer, but replace the tutorial's WebSocket chat protocol with OtterLink's existing HTTP/API and JSON-lines protocol. Do not add a new chat backend and do not make the iOS client depend on Vapor.

### Suggested layers

- OtterLinkClient — authenticated HTTP API and the existing OtterLink JSON-lines realtime connection.
- SessionStore — login/session state, current user, connection state, and reconnect handling.
- Models — Codable models matching OtterLink server responses rather than the tutorial's UUID/user/message structures.
- ConversationStore — communities, channels, PM conversations, message history, unread state.
- SwiftUI views — rendering only; no protocol or authentication logic in views.

## First implementation target

1. Get the app to connect to an OtterLink server.
2. Authenticate and retain the server session/token exactly as the existing server expects.
3. Load the current user and People/community data through the existing HTTP API.
4. Add a single conversation view backed by the existing realtime JSON-lines connection.
5. Add PMs after normal chat works.
6. Reuse the same destination/model concepts for Home, Events, and future services.

The Qt client remains the reference for behavior and API semantics; this app should not invent parallel server concepts.

## Transport notes

The current OtterLink server exposes:
- HTTP API: :9090
- JSON-lines protocol: :8023
- OSCAR compatibility: :5190

The iOS client should use the HTTP API for request/response operations and the JSON-lines service for realtime events/messages. OSCAR is not needed for the native iOS client.

## SwiftUI design goals

- iPhone: NavigationStack and touch-first layouts.
- iPad: NavigationSplitView where appropriate.
- Keep model/transport code independent of SwiftUI so it can be tested.
- Use async/await where the deployment target permits it.
- Make connection/reconnect state visible without turning the UI into a network debugger.
- Keep the retro OtterLink personality in the presentation layer rather than baking it into protocol code.

## What not to carry forward

- The tutorial's Vapor server.
- A second chat protocol.
- Hard-coded localhost WebSocket assumptions.
- Tutorial-era SwiftUI patterns that make networking part of a View.
- A second source of truth for users, communities, events, or messages.

## Next code step

Create an OtterLinkCore layer first, with protocol-facing Codable types and a small OtterLinkAPI client. Then replace the tutorial's chat screen data source with an adapter backed by that layer. This keeps the initial change small and gives us a clean path to the eventual iPhone/iPad client described in OtterLink issue #43.


## Initial implementation completed

The branch now has a real OtterLink-oriented app shell rather than only adaptation notes:

- Replaced the tutorial's settings-first root with Home / People / Communities / Chat / Settings navigation.
- Removed the tutorial's hard-coded `ws://127.0.0.1:8080/chat` client transport.
- Added `OtterLinkAPI` for the existing HTTP API, including the known `GET /api/health` endpoint.
- Added `OtterLinkSession` for shared server URL, reachability and app-wide connection state.
- Added native destination placeholders for People, Communities and Events so the UI structure can be exercised before each service is wired.
- Added basic local persistence for the username and a stable local UUID.
- Kept the realtime transport as a protocol abstraction rather than guessing at the JSON-lines handshake.

The Xcode project includes the new Swift files in both iOS and macOS targets.

## Next implementation target

The next meaningful step is not more UI scaffolding: inspect the Qt6 client's actual authentication/request and JSON-lines message envelopes and reproduce those semantics in the Swift transport. Once that is done, the placeholder People/Communities/Chat screens can be replaced incrementally without changing the app shell.
