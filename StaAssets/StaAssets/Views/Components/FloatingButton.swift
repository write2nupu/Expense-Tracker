
import SwiftUI

struct FloatingActionButton: View {
    
    var action: () -> Void
    
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button {
                    action()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .font(.title2.bold())
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
            }
        }
    }
}
