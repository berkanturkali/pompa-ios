import SwiftUI

struct PompaBottomSheetHandle: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(PompaColors.border.opacity(0.6))
                .frame(width: 28, height: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        VStack {
            PompaBottomSheetHandle()
            Spacer()
        }
    }
}
