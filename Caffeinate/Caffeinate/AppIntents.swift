import AppIntents

/// Turn keep-awake on. Use in a Shortcuts personal automation such as
/// "When <app> is opened → Run Keep Device Awake".
struct StartCaffeinateIntent: AppIntent {
    static var title: LocalizedStringResource = "Keep Device Awake"
    static var description = IntentDescription(
        "Prevents the device from auto-locking. Pair with an app-open automation.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        KeepAwakeManager.shared.setActive(true)
        return .result(dialog: "Device will stay awake.")
    }
}

/// Turn keep-awake off. Use in a "When <app> is closed" automation.
struct StopCaffeinateIntent: AppIntent {
    static var title: LocalizedStringResource = "Allow Device to Sleep"
    static var description = IntentDescription(
        "Restores normal auto-lock behavior.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        KeepAwakeManager.shared.setActive(false)
        BrightnessController.shared.restore()
        return .result(dialog: "Device can sleep normally now.")
    }
}

/// Flip the current state.
struct ToggleCaffeinateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Keep Device Awake"
    static var description = IntentDescription(
        "Turns keep-awake on if it's off, or off if it's on.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let manager = KeepAwakeManager.shared
        manager.toggle()
        if !manager.isActive {
            BrightnessController.shared.restore()
        }
        return .result(dialog: manager.isActive
            ? "Device will stay awake."
            : "Device can sleep normally now.")
    }
}

/// Report the current state, e.g. for use in "If" conditions in Shortcuts.
struct CaffeinateStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Is Device Being Kept Awake"
    static var description = IntentDescription(
        "Returns true when a keep-awake session is active.")
    static var openAppWhenRun: Bool = false

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Bool> & ProvidesDialog {
        let active = KeepAwakeManager.shared.isActive
        return .result(value: active,
                       dialog: active ? "Yes, the device is being kept awake."
                                      : "No, sleep is normal.")
    }
}

struct CaffeinateShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartCaffeinateIntent(),
            phrases: [
                "Keep \(.applicationName) awake",
                "Start \(.applicationName)",
            ],
            shortTitle: "Keep Awake",
            systemImageName: "cup.and.saucer.fill")
        AppShortcut(
            intent: StopCaffeinateIntent(),
            phrases: [
                "Let \(.applicationName) sleep",
                "Stop \(.applicationName)",
            ],
            shortTitle: "Allow Sleep",
            systemImageName: "moon.zzz.fill")
        AppShortcut(
            intent: ToggleCaffeinateIntent(),
            phrases: [
                "Toggle \(.applicationName)",
            ],
            shortTitle: "Toggle",
            systemImageName: "powersleep")
    }
}
