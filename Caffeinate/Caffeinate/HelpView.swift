import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("What this does") {
                    Text("While Caffeinate is on, the device won't auto-lock or "
                         + "dim to sleep. Turning it off restores your normal "
                         + "Auto-Lock setting.")
                }

                Section("Keep awake only for certain apps") {
                    Text("iOS won't let one app watch another, but the Shortcuts "
                         + "app can. Set up a personal automation:")
                    stepRow(1, "Open the **Shortcuts** app → **Automation** tab → **＋**.")
                    stepRow(2, "Choose **App**, pick the app(s), select **Is Opened**, "
                            + "and turn off **Ask Before Running**.")
                    stepRow(3, "Add action **Keep Device Awake** (from Caffeinate).")
                    stepRow(4, "Create a second automation for the same app(s) with "
                            + "**Is Closed** and the action **Allow Device to Sleep**.")
                }

                Section("Available Shortcuts actions") {
                    actionRow("cup.and.saucer.fill", "Keep Device Awake")
                    actionRow("moon.zzz.fill", "Allow Device to Sleep")
                    actionRow("powersleep", "Toggle Keep Device Awake")
                    actionRow("questionmark.circle", "Is Device Being Kept Awake")
                }

                Section("Notes") {
                    Text("• Keep-awake only takes effect while some app using this "
                         + "flag is in the foreground; the app-open automation "
                         + "handles that.\n"
                         + "• If the device restarts, re-open Caffeinate once to "
                         + "restore the session.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("How it works")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func stepRow(_ n: Int, _ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("\(n)")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Color.accentColor, in: Circle())
            Text(.init(text))
        }
    }

    private func actionRow(_ symbol: String, _ name: String) -> some View {
        Label {
            Text(name)
        } icon: {
            Image(systemName: symbol).foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    HelpView()
}
