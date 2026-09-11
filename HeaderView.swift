import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("ChromaSlide")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                scoreBlock(title: "Score", value: viewModel.score)
                scoreBlock(title: "Best", value: viewModel.bestScore)
            }

            HStack {
                Text("Target color")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                Circle()
                    .fill(ColorMixer.color(for: viewModel.targetColor))
                    .frame(width: 22, height: 22)
                    .overlay(Circle().strokeBorder(.white.opacity(0.6), lineWidth: 2))
                Text(viewModel.targetColor)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Spacer()
                if viewModel.lastTargetBonus > 0 {
                    Text("+\(viewModel.lastTargetBonus) bonus")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.green)
                        .transition(.opacity)
                }
            }
        }
        .padding(.horizontal, 18)
    }

    private func scoreBlock(title: String, value: Int) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(title)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
            Text("\(value)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.leading, 14)
    }
}
