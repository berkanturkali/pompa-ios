import SwiftUI

struct ProvinceItem: View {
    let province: Province
    let onItemClick: () -> Void

    var body: some View {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(PompaColors.Card.primaryBackground)
                        .overlay(
                            Circle()
                                .stroke(PompaColors.border, lineWidth: 1)
                        )

                    Text(province.code)
                        .font(PompaTypography.font(size: 14, weight: .bold))
                        .foregroundStyle(PompaColors.Text.primary)
                }
                .frame(width: 48, height: 48)

                Text(province.name.titleCased)
                    .font(PompaTypography.font(size: 14, weight: .semibold))
                    .foregroundStyle(PompaColors.Text.primary)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(PompaColors.Card.primaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(PompaColors.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
            .onTapGesture {
                onItemClick()
            }
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        ProvinceItem(
            province: Province(id: 34, name: "Istanbul", code: "34"),
            onItemClick: {}
        )
    }
}
