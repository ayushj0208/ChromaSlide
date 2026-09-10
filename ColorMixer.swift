import SwiftUI

/// ColorMixer defines every paint color in the game and the rules for
/// blending two different colors together when their tiles collide.
/// This mixing graph is the twist that separates ChromaSlide from a
/// standard number based sliding puzzle: tiles combine like paint,
/// not like arithmetic.
enum ColorMixer {

    /// Primary colors that spawn on the board.
    static let primaries = ["Red", "Blue", "Yellow"]

    /// Every color reachable in the game, grouped by tier for spawn
    /// weighting and win detection.
    static let tierOf: [String: Int] = [
        "Red": 1, "Blue": 1, "Yellow": 1,
        "Orange": 2, "Purple": 2, "Green": 2,
        "Vermillion": 3, "Amber": 3, "Magenta": 3,
        "Indigo": 3, "Teal": 3, "Lime": 3,
        "Brown": 4, "Slate": 4, "Olive": 4,
        "Charcoal": 5
    ]

    /// Hex swatches for each color, chosen for good contrast on a dark board.
    static let hex: [String: String] = [
        "Red": "#E63946",
        "Blue": "#457B9D",
        "Yellow": "#F4C542",
        "Orange": "#F3722C",
        "Purple": "#7B2CBF",
        "Green": "#43AA8B",
        "Vermillion": "#D62828",
        "Amber": "#FFB703",
        "Magenta": "#C9184A",
        "Indigo": "#3A0CA3",
        "Teal": "#0A9396",
        "Lime": "#94D82D",
        "Brown": "#6F4518",
        "Slate": "#4A4E69",
        "Olive": "#606C38",
        "Charcoal": "#22223B"
    ]

    /// Two different colors that collide blend into a new color, if a
    /// recipe exists. Colors with no listed recipe simply block each
    /// other and will not merge.
    private static let recipes: [Set<String>: String] = [
        Set(["Red", "Yellow"]): "Orange",
        Set(["Red", "Blue"]): "Purple",
        Set(["Blue", "Yellow"]): "Green",
        Set(["Red", "Orange"]): "Vermillion",
        Set(["Yellow", "Orange"]): "Amber",
        Set(["Red", "Purple"]): "Magenta",
        Set(["Blue", "Purple"]): "Indigo",
        Set(["Blue", "Green"]): "Teal",
        Set(["Yellow", "Green"]): "Lime",
        Set(["Orange", "Purple"]): "Brown",
        Set(["Green", "Purple"]): "Slate",
        Set(["Orange", "Green"]): "Olive",
        Set(["Brown", "Slate"]): "Charcoal",
        Set(["Brown", "Olive"]): "Charcoal",
        Set(["Slate", "Olive"]): "Charcoal"
    ]

    static func color(for name: String) -> Color {
        Color(hex: hex[name] ?? "#CCCCCC")
    }

    /// Returns the resulting color name if two different colors can mix,
    /// or nil if there is no recipe for that pairing.
    static func mix(_ a: String, _ b: String) -> String? {
        guard a != b else { return nil }
        return recipes[Set([a, b])]
    }

    /// A random starting color for freshly spawned tiles, weighted toward
    /// the three primaries so the board stays readable.
    static func randomSpawnColor() -> String {
        primaries.randomElement() ?? "Red"
    }

    /// Points awarded for a merge, scaled by the tier of the resulting color.
    static func mergeScore(for colorName: String) -> Int {
        (tierOf[colorName] ?? 1) * 10
    }

    /// A random target color used for the bonus objective banner.
    /// Restricted to tier 2 and 3 so targets stay reachable within a
    /// reasonable number of moves.
    static func randomTarget() -> String {
        let candidates = tierOf.filter { $0.value == 2 || $0.value == 3 }.map { $0.key }
        return candidates.randomElement() ?? "Orange"
    }
}
