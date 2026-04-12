import SwiftUI

struct PompaLoadingView: View {
    let backgroundColor: Color
    let progressColor: Color
    let containerSize: CGFloat
    let indicatorSize: CGFloat
    let strokeWidth: CGFloat
    let onDismiss: () -> Void

    init(
        backgroundColor: Color = PompaColors.PullToRefresh.container,
        progressColor: Color = PompaColors.PullToRefresh.content,
        containerSize: CGFloat = 56,
        indicatorSize: CGFloat = 30,
        strokeWidth: CGFloat = 3,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.backgroundColor = backgroundColor
        self.progressColor = progressColor
        self.containerSize = containerSize
        self.indicatorSize = indicatorSize
        self.strokeWidth = strokeWidth
        self.onDismiss = onDismiss
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            Circle()
                .fill(backgroundColor)
                .frame(width: containerSize, height: containerSize)
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(progressColor)
                        .scaleEffect(indicatorSize / 20)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        PompaLoadingView()
    }
}
