import SwiftUI

struct PriceDateView: View {
    let date: String

    var body: some View {
        HStack {
            Spacer()

            HStack(spacing: 2) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(PompaColors.Text.primary.opacity(0.8))

                Text(date)
                    .font(PompaTypography.font(size: 11, weight: .semibold))
                    .foregroundStyle(PompaColors.Text.primary.opacity(0.8))
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .background(PompaColors.Card.primaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(PompaColors.border, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        PriceDateView(date: "11/04/2026")
            .padding(16)
    }
}
