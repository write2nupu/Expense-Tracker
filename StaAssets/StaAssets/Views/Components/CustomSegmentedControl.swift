
import SwiftUI

struct CustomSegmentedControl: View {
    
    @Binding var selectedIndex: Int
    var titles: [String]
    
    var body: some View {
        
        GeometryReader { geo in
            
            let width = geo.size.width / CGFloat(titles.count)
            
            ZStack(alignment: .leading) {
                
                // Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white.opacity(0.08))
                
                // Sliding Indicator
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(width: width)
                    .offset(x: CGFloat(selectedIndex) * width)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedIndex)
                
                // Tabs
                HStack(spacing: 0) {
                    
                    ForEach(Array(titles.enumerated()), id: \.offset) { index, title in
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedIndex = index
                            }
                        } label: {
                            Text(title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(
                                    selectedIndex == index ? .black : .gray
                                )
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
            }
        }
        .frame(height: 50)
    }
}
