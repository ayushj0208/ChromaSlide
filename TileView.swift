import SwiftUI

struct TileView: View {
    let tile: Tile
    let cellSize: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(ColorMixer.color(for: tile.colorName))
                .shadow(color: .black.opacity(0.25), radius: tile.power > 1 ? 8 : 3, x: 0, y: 3)

            if tile.power > 1 {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.7), lineWidth: 3)
            }

            VStack(spacing: 2) {
                Text(tile.colorName)
                    .font(.system(size: cellSize * 0.13, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if tile.power > 1 {
                    Text("x\(tile.power)")
                        .font(.system(size: cellSize * 0.15, weight: .bold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding(6)
        }
        .frame(width: cellSize, height: cellSize)
        .scaleEffect(tile.justSpawned ? 0.6 : (tile.justMerged ? 1.08 : 1.0))
        .animation(.spring(response: 0.28, dampingFraction: 0.6), value: tile.justSpawned)
        .animation(.spring(response: 0.22, dampingFraction: 0.5), value: tile.justMerged)
    }
}
