import UIKit

/// Optionally lowers screen brightness while a keep-awake session is running.
///
/// Remembers the brightness at the moment we dim so it can be put back. If the
/// user manually changes brightness while dimmed, `restore()` won't fight them
/// beyond a one-time reset.
@MainActor
final class BrightnessController {

    static let shared = BrightnessController()

    /// Brightness to drop to when dimming (0...1).
    private let dimLevel: CGFloat = 0.15

    private var savedBrightness: CGFloat?

    private init() {}

    func dim() {
        if savedBrightness == nil {
            savedBrightness = UIScreen.main.brightness
        }
        UIScreen.main.brightness = dimLevel
    }

    func restore() {
        guard let saved = savedBrightness else { return }
        UIScreen.main.brightness = saved
        savedBrightness = nil
    }
}
