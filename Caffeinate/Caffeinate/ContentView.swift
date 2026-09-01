import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var manager: KeepAwakeManager
    @AppStorage("dimWhileAwake") private var dimWhileAwake = false
    @State private var showingHelp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()

                Text(manager.isActive ? "Device stays awake" : "Normal sleep")
                    .font(.headline)
                    .foregroundStyle(manager.isActive ? .primary : .secondary)
                    .animation(.default, value: manager.isActive)

                Button {
                    withAnimation { manager.toggle() }
                    applyBrightnessIfNeeded()
                } label: {
                    ZStack {
                        Circle()
                            .fill(manager.isActive
                                  ? AnyShapeStyle(Color.accentColor.gradient)
                                  : AnyShapeStyle(Color(.systemGray5)))
                            .frame(width: 200, height: 200)
                            .shadow(color: manager.isActive ? Color.accentColor.opacity(0.5) : .clear,
                                    radius: 24)

                        Image(systemName: manager.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                            .font(.system(size: 72))
                            .foregroundStyle(manager.isActive ? .white : .secondary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(manager.isActive ? "Turn off keep awake" : "Turn on keep awake")

                Text(manager.isActive ? "Tap to let the device sleep" : "Tap to keep the device awake")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .navigationTitle("Caffeinate")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                    .accessibilityLabel("Help")
                }
            }
            .safeAreaInset(edge: .bottom) {
                settingsCard
            }
            .sheet(isPresented: $showingHelp) {
                HelpView()
            }
            .onAppear { applyBrightnessIfNeeded() }
        }
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            Toggle(isOn: $dimWhileAwake) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dim screen while awake")
                    Text("Lowers brightness to save battery")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .onChange(of: dimWhileAwake) { _, _ in applyBrightnessIfNeeded() }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func applyBrightnessIfNeeded() {
        guard dimWhileAwake else {
            BrightnessController.shared.restore()
            return
        }
        if manager.isActive {
            BrightnessController.shared.dim()
        } else {
            BrightnessController.shared.restore()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(KeepAwakeManager.shared)
}
