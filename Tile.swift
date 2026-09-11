import Foundation

/// A single paint tile on the board.
struct Tile: Identifiable, Equatable {
    let id: UUID
    var colorName: String
    /// Power increases when two tiles of the SAME color merge. It has no
    /// gameplay effect beyond a visual glow and score bonus, giving the
    /// player a secondary thing to build toward besides mixing colors.
    var power: Int
    var row: Int
    var col: Int
    var justSpawned: Bool
    var justMerged: Bool

    init(colorName: String, row: Int, col: Int, power: Int = 1, justSpawned: Bool = true, justMerged: Bool = false) {
        self.id = UUID()
        self.colorName = colorName
        self.row = row
        self.col = col
        self.power = power
        self.justSpawned = justSpawned
        self.justMerged = justMerged
    }
}
