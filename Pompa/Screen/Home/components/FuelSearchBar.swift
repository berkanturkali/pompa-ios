import SwiftUI

struct FuelSearchBar: View {
    let value: String
    let onValueChanged: (String) -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(PompaColors.SearchBar.startIcon)

            ZStack(alignment: .leading) {
                if value.isEmpty && !isFocused {
                    Text(LocalizedStrings.fuelSearchBarHint)
                        .font(PompaTypography.font(size: 11, weight: .medium, italic: true))
                        .foregroundStyle(PompaColors.SearchBar.hint)
                }

                TextField("", text: binding)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .font(PompaTypography.font(size: 13, weight: .medium))
                    .foregroundStyle(PompaColors.SearchBar.text)
                    .tint(PompaColors.SearchBar.cursor)
                    .onSubmit {
                        isFocused = false
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if !value.isEmpty {
                Button {
                    onValueChanged("")
                    isFocused = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(PompaColors.SearchBar.closeIcon)
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .padding(.trailing, 8)
            }
        }
        .frame(height: 20)
        .padding(8)
        .background(PompaColors.SearchBar.background)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(PompaColors.border, lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.08), radius: 1, y: 1)
        .animation(.easeInOut(duration: 0.2), value: value.isEmpty)
    }

    private var binding: Binding<String> {
        Binding(
            get: { value },
            set: { newValue in
                onValueChanged(newValue)

                if newValue.isEmpty {
                    isFocused = false
                }
            }
        )
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        VStack(spacing: 16) {
            FuelSearchBar(value: "", onValueChanged: { _ in })
            FuelSearchBar(value: "Opet", onValueChanged: { _ in })
        }
        .padding(16)
    }
}
