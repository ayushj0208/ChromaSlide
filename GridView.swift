import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: GameViewModel

    private let spacing: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            let boardSize = min(geo.size.width, geo.size.height)
            let cellSize = (boardSize - spacing * CGFloat(GameViewModel.boardSize + 1)) / CGFloat(GameViewModel.boardSize)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.black.opacity(0.25))
                    .frame(width: boardSize, height: boardSize)

                backgroundGrid(cellSize: cellSize)

                ForEach(viewModel.tiles) { tile in
                    TileView(tile: tile, cellSize: cellSize)
                        .position(
                            x: spacing + cellSize / 2 + CGFloat(tile.col) * (cellSize + spacing),
                            y: spacing + cellSize / 2 + CGFloat(tile.row) * (cellSize + spacing)
                        )
                        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: tile.row)
                        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: tile.col)
                }
            }
            .frame(width: boardSize, height: boardSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func backgroundGrid(cellSize: CGFloat) -> some View {
        VStack(spacing: spacing) {
            ForEach(0..<GameViewModel.boardSize, id: \.self) { _ in
                HStack(spacing: spacing) {
                    ForEach(0..<GameViewModel.boardSize, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.06))
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
        .padding(spacing)
    }
}
