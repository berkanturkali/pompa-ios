import SwiftUI

struct ProviderEmptyView: View {
    let provider: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color(.lightGray))

            Text(LocalizedStrings.providerEmptyResult(provider))
                .font(PompaTypography.font(size: 11, weight: .semibold))
                .foregroundStyle(Color(.lightGray))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
        .padding(.vertical, 24)
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(PompaColors.border, lineWidth: 0.5)
        )
        .padding(.horizontal, 8)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        ProviderEmptyView(provider: "Opet")
            .padding(16)
    }
}
