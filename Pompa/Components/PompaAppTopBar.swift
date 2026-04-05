//

import SwiftUI

struct PompaAppTopBar: View {
    let showBackButton: Bool
    let showSelectedProvince: Bool
    let title: String
    let provinceName: String
    let provinceCode: String
    let onBackButtonClick: () -> Void
    let onSelectedProvinceClick: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(title)
                    .font(PompaTypography.font(size: 14, weight: .semibold))
                    .foregroundStyle(PompaColors.TopBar.content)
                    .lineLimit(1)
                    .padding(.horizontal, 72)
                
                HStack {
                    if showBackButton {
                        Button(action: onBackButtonClick) {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(PompaColors.TopBar.content)
                                .frame(width: 32, height: 32)
                                .background(PompaColors.Card.primaryBackground)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(PompaColors.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    }
                    
                    Spacer()
                    
                    if showSelectedProvince {
                        Button(action: onSelectedProvinceClick) {
                            VStack(spacing: 3) {
                                ZStack {
                                    Circle()
                                        .fill(PompaColors.Card.primaryBackground)
                                        .overlay(
                                            Circle()
                                                .stroke(PompaColors.border, lineWidth: 1)
                                        )
                                    
                                    Text(provinceCode.uppercased())
                                        .font(PompaTypography.font(size: 8, weight: .bold))
                                        .foregroundStyle(PompaColors.TopBar.content)
                                }
                                .frame(width: 18, height: 18)
                                
                                
                                Text(provinceName.titleCased)
                                    .font(PompaTypography.font(size: 10, weight: .semibold))
                                    .foregroundStyle(PompaColors.TopBar.content)
                                    .lineLimit(1)
                                
                            }
                            .frame(minWidth: 56)
                        }
                        .buttonStyle(.plain)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            .background(PompaColors.TopBar.background)
            .animation(.spring(response: 0.28, dampingFraction: 0.86), value: showBackButton)
            .animation(.spring(response: 0.28, dampingFraction: 0.86), value: showSelectedProvince)
            
            Rectangle()
                .fill(PompaColors.border)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack(alignment: .top) {
        PompaColors.Background.primary
            .ignoresSafeArea()
        
        PompaAppTopBar(
            showBackButton: true,
            showSelectedProvince: true,
            title: "Provinces",
            provinceName: "Istanbul",
            provinceCode: "34",
            onBackButtonClick: {},
            onSelectedProvinceClick: {}
        )
    }
}
