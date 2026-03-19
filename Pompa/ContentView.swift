//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            PompaColors.Background.primary
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pompa")
                        .font(.largeTitle.bold())
                        .foregroundStyle(PompaColors.Text.primary)

                    Text("The iOS theme now matches your Android palette.")
                        .foregroundStyle(PompaColors.Text.secondary)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Featured Card")
                        .font(.headline)
                        .foregroundStyle(PompaColors.Text.primary)

                    Text("Primary surfaces, borders, text, and CTA colors are mapped into SwiftUI so you can reuse them across screens.")
                        .foregroundStyle(PompaColors.Text.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button("Continue") {
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(PompaColors.Button.filledPrimaryBackground)
                    .foregroundStyle(PompaColors.Button.filledPrimaryContent)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PompaColors.Card.primaryBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(PompaColors.border, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                HStack(spacing: 12) {
                    chip(title: "Diesel", selected: true)
                    chip(title: "LPG", selected: false)
                    chip(title: "EV", selected: false)
                }

                Spacer()
            }
            .padding(24)
        }
    }

    private func chip(title: String, selected: Bool) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(selected ? PompaColors.Chip.selectedText : PompaColors.Chip.unselectedText)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(selected ? PompaColors.Chip.selectedBackground : PompaColors.Chip.unselectedBackground)
            .overlay(
                Capsule()
                    .stroke(
                        selected ? PompaColors.Chip.selectedBorder : PompaColors.Chip.unselectedBorder,
                        lineWidth: 1
                    )
            )
            .clipShape(Capsule())
    }
}

#Preview {
    ContentView()
}
