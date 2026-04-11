import SwiftUI

struct SortButton: View {
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            ZStack {
                Circle()
                    .fill(PompaColors.Card.primaryBackground)

                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(PompaColors.Text.primary)
            }
            .frame(width: 28, height: 28)
            .overlay(
                Circle()
                    .stroke(PompaColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        SortButton(onClick: {})
    }
}
