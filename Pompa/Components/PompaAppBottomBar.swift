import SwiftUI

struct PompaAppBottomBar: View {
    let destinations: [BottomNavDestination]
    let selectedDestination: BottomNavDestination
    let onDestinationSelected: (BottomNavDestination) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(PompaColors.border)
                .frame(height: 1)
            
            HStack(spacing: 0) {
                ForEach(destinations) { destination in
                    bottomBarItem(for: destination)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(PompaColors.BottomBar.background)
        }
    }
    
    @ViewBuilder
    private func bottomBarItem(for destination: BottomNavDestination) -> some View {
        let isSelected = destination == selectedDestination
        
        Button(action: {
            onDestinationSelected(destination)
        }) {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(PompaColors.BottomBar.indicator)
                        .frame(width: 56, height: 40)
                }
                
                VStack(spacing: 2) {
                    Image(systemName: destination.iconSystemName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            isSelected
                            ? PompaColors.BottomBar.selectedItem
                            : PompaColors.BottomBar.unselectedItem
                        )
                    
                    if isSelected {
                        Circle()
                            .fill(PompaColors.BottomBar.selectedItem)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: 56, height: 40)
    }
}

#Preview {
    VStack {
        Spacer()
        PompaAppBottomBar(
            destinations: BottomNavDestination.allCases,
            selectedDestination: .home,
            onDestinationSelected: { _ in }
        )
    }
    .background(PompaColors.Background.primary)
}
