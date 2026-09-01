import SwiftUI
import Combine
import UIKit

/// Single source of truth for whether the device should be kept awake.
///
/// The actual "keep awake" mechanism is `UIApplication.shared.isIdleTimerDisabled`.
/// That flag only has an effect while the app is in the foreground, so we also
/// re-apply it whenever the app becomes active.
@MainActor
final class KeepAwakeManager: ObservableObject {

    static let shared = KeepAwakeManager()

    private let defaultsKey = "keepAwakeEnabled"

    /// Whether the user has an active keep-awake session.
    /// Persisted so a relaunch (e.g. after the app is jettisoned) restores state.
    @Published private(set) var isActive: Bool {
        didSet {
            UserDefaults.standard.set(isActive, forKey: defaultsKey)
            applyIdleTimer()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private init() {
        self.isActive = UserDefaults.standard.bool(forKey: defaultsKey)
        applyIdleTimer()

        // The idle-timer flag is reset by the system across app launches and can
        // be cleared when returning to foreground, so re-assert it on activation.
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in self?.applyIdleTimer() }
            .store(in: &cancellables)
    }

    func setActive(_ active: Bool) {
        guard active != isActive else { return }
        isActive = active
    }

    func toggle() {
        isActive.toggle()
    }

    private func applyIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = isActive
    }
}
