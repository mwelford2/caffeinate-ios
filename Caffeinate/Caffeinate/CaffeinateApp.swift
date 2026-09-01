import SwiftUI

@main
struct CaffeinateApp: App {
    @StateObject private var manager = KeepAwakeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
