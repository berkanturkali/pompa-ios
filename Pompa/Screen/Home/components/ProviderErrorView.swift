import SwiftUI

struct ProviderErrorView: View {
    let provider: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "face.smiling.inverse")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color(.lightGray))

            Text(LocalizedStrings.providerFetchError(provider))
                .font(PompaTypography.font(size: 11, weight: .medium))
                .foregroundStyle(Color(.lightGray))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        ProviderErrorView(provider: "Opet")
            .padding(16)
    }
}
