import SwiftUI
import Foundation

enum SlideDirection {
    case up, down, left, right
}

final class GameViewModel: ObservableObject {
    static let boardSize = 4

    @Published private(set) var tiles: [Tile] = []
    @Published private(set) var score = 0
    @Published private(set) var bestScore = 0
    @Published private(set) var targetColor = ColorMixer.randomTarget()
    @Published private(set) var isGameOver = false
    @Published var lastTargetBonus = 0

    private let bestScoreKey = "ChromaSlide.bestScore"

    init() {
        bestScore = UserDefaults.standard.integer(forKey: bestScoreKey)
        startNewGame()
    }

    func startNewGame() {
        tiles = []
        score = 0
        isGameOver = false
        targetColor = ColorMixer.randomTarget()
        spawnTile()
        spawnTile()
    }

    // MARK: - Board helpers

    private func occupiedPositions() -> Set<Int> {
        Set(tiles.map { $0.row * Self.boardSize + $0.col })
    }

    private func spawnTile() {
        let occupied = occupiedPositions()
        var empties: [(Int, Int)] = []
        for r in 0..<Self.boardSize {
            for c in 0..<Self.boardSize {
                if !occupied.contains(r * Self.boardSize + c) {
                    empties.append((r, c))
                }
            }
        }
        guard let spot = empties.randomElement() else { return }
        let newTile = Tile(colorName: ColorMixer.randomSpawnColor(), row: spot.0, col: spot.1)
        tiles.append(newTile)
    }

    // MARK: - Moves

    func move(_ direction: SlideDirection) {
        guard !isGameOver else { return }

        var board = emptyGrid()
        for t in tiles {
            board[t.row][t.col] = t
        }
        let beforeSignature = signature(for: board)

        var totalScored = 0
        var targetHit = false

        switch direction {
        case .left:
            for r in 0..<Self.boardSize {
                let line = board[r].compactMap { $0 }
                let outcome = slideLine(line)
                totalScored += outcome.scored
                targetHit = targetHit || outcome.targetHit
                board[r] = pad(outcome.result, row: r, columnMajor: false)
            }
        case .right:
            for r in 0..<Self.boardSize {
                let line = board[r].compactMap { $0 }.reversed().map { $0 }
                let outcome = slideLine(line)
                totalScored += outcome.scored
                targetHit = targetHit || outcome.targetHit
                let padded = pad(outcome.result, row: r, columnMajor: false)
                board[r] = padded.reversed().map { $0 }
                board[r] = reindexRow(board[r], row: r)
            }
        case .up:
            for c in 0..<Self.boardSize {
                let colTiles = (0..<Self.boardSize).compactMap { board[$0][c] }
                let outcome = slideLine(colTiles)
                totalScored += outcome.scored
                targetHit = targetHit || outcome.targetHit
                let padded = pad(outcome.result, row: 0, columnMajor: true, col: c)
                for r in 0..<Self.boardSize {
                    board[r][c] = padded[r]
                }
            }
        case .down:
            for c in 0..<Self.boardSize {
                let colTiles = (0..<Self.boardSize).compactMap { board[$0][c] }.reversed().map { $0 }
                let outcome = slideLine(colTiles)
                totalScored += outcome.scored
                targetHit = targetHit || outcome.targetHit
                var padded = pad(outcome.result, row: 0, columnMajor: true, col: c)
                padded.reverse()
                for r in 0..<Self.boardSize {
                    var t = padded[r]
                    t?.row = r
                    t?.col = c
                    board[r][c] = t
                }
            }
        }

        // Compare full board snapshots (not just per line merge counts) so
        // that tiles sliding into empty gaps without merging still count
        // as a valid move, matching how sliding puzzles are expected to feel.
        guard signature(for: board) != beforeSignature else { return }

        tiles = board.flatMap { $0 }.compactMap { $0 }
        score += totalScored

        if targetHit {
            lastTargetBonus = ColorMixer.mergeScore(for: targetColor) * 2
            score += lastTargetBonus
            targetColor = ColorMixer.randomTarget()
        } else {
            lastTargetBonus = 0
        }

        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
        }

        spawnTile()
        isGameOver = !movesRemain()
    }

    // MARK: - Line processing

    private func slideLine(_ input: [Tile]) -> (result: [Tile], scored: Int, targetHit: Bool) {
        var result: [Tile] = []
        var scored = 0
        var targetHit = false
        var i = 0

        while i < input.count {
            var current = input[i]
            current.justMerged = false
            current.justSpawned = false

            if i < input.count - 1 {
                let next = input[i + 1]
                if current.colorName == next.colorName {
                    current.power += 1
                    current.justMerged = true
                    scored += ColorMixer.mergeScore(for: current.colorName) * current.power
                    if current.colorName == targetColor { targetHit = true }
                    result.append(current)
                    i += 2
                    continue
                } else if let mixed = ColorMixer.mix(current.colorName, next.colorName) {
                    current.colorName = mixed
                    current.power = 1
                    current.justMerged = true
                    scored += ColorMixer.mergeScore(for: mixed)
                    if mixed == targetColor { targetHit = true }
                    result.append(current)
                    i += 2
                    continue
                }
            }

            result.append(current)
            i += 1
        }

        return (result, scored, targetHit)
    }

    /// A simple positional fingerprint of the board, used to detect whether
    /// a move actually changed anything (including gap closing moves that
    /// do not involve a merge).
    private func signature(for board: [[Tile?]]) -> String {
        board.flatMap { row in
            row.map { cell -> String in
                guard let cell else { return "." }
                return "\(cell.colorName):\(cell.power)"
            }
        }.joined(separator: ",")
    }

    /// Pads a compacted line back out to full board size, assigning
    /// row and col for each tile based on its final position.
    private func pad(_ line: [Tile], row: Int, columnMajor: Bool, col: Int = 0) -> [Tile?] {
        var out: [Tile?] = line.map { $0 }
        while out.count < Self.boardSize {
            out.append(nil)
        }
        for i in 0..<out.count {
            if columnMajor {
                out[i]?.row = i
                out[i]?.col = col
            } else {
                out[i]?.row = row
                out[i]?.col = i
            }
        }
        return out
    }

    private func reindexRow(_ row: [Tile?], row rowIndex: Int) -> [Tile?] {
        var result = row
        for i in 0..<result.count {
            result[i]?.row = rowIndex
            result[i]?.col = i
        }
        return result
    }

    private func emptyGrid() -> [[Tile?]] {
        Array(repeating: Array(repeating: nil, count: Self.boardSize), count: Self.boardSize)
    }

    // MARK: - Game over detection

    private func movesRemain() -> Bool {
        if tiles.count < Self.boardSize * Self.boardSize { return true }

        var grid = emptyGrid()
        for t in tiles { grid[t.row][t.col] = t }

        for r in 0..<Self.boardSize {
            for c in 0..<Self.boardSize {
                guard let current = grid[r][c] else { continue }
                if c + 1 < Self.boardSize, let right = grid[r][c + 1] {
                    if right.colorName == current.colorName { return true }
                    if ColorMixer.mix(current.colorName, right.colorName) != nil { return true }
                }
                if r + 1 < Self.boardSize, let down = grid[r + 1][c] {
                    if down.colorName == current.colorName { return true }
                    if ColorMixer.mix(current.colorName, down.colorName) != nil { return true }
                }
            }
        }
        return false
    }
}
