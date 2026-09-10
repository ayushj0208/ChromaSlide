import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#1B1B2F"), Color(hex: "#0F0F1A")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HeaderView(viewModel: viewModel)
                    .padding(.top, 12)

                GridView(viewModel: viewModel)
                    .padding(.horizontal, 18)

                Text("Swipe to slide. Same colors merge and grow. Different colors blend into new paints.")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()
            }

            if viewModel.isGameOver {
                gameOverOverlay
            }
        }
        .gesture(
            DragGesture(minimumDistance: 24)
                .onEnded { value in
                    handleSwipe(value.translation)
                }
        )
    }

    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Board full")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text("Final score \(viewModel.score)")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                Button {
                    viewModel.startNewGame()
                } label: {
                    Text("Play again")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(Color.white, in: Capsule())
                }
            }
            .padding(28)
            .background(Color(hex: "#1B1B2F"), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }

    private func handleSwipe(_ translation: CGSize) {
        let horizontalAmount = translation.width
        let verticalAmount = translation.height

        if abs(horizontalAmount) > abs(verticalAmount) {
            viewModel.move(horizontalAmount > 0 ? .right : .left)
        } else {
            viewModel.move(verticalAmount > 0 ? .down : .up)
        }
    }
}

#Preview {
    ContentView()
}
