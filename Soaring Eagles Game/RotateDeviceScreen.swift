import Foundation
import SwiftUI



struct RotateDeviceScreen: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image(systemName: "rectangle.landscape.rotate")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding()
                    .shadow(radius: 10)
                Text("To continue, rotate the device screen to horizontal orientation")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(radius: 20)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(20)
                    
            }
                .frame(width: geometry.size.width)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            
            
        }
        .background(
            Image(.background1)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            )
        
        
        
    }
}



#Preview {
    RotateDeviceScreen()
}
