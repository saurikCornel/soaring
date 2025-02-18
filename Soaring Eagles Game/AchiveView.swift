import SwiftUI

struct AchiveView: View {
    @AppStorage("achive1") var achive1: Int = 0
    @AppStorage("achive2") var achive2: Int = 0
    @AppStorage("achive3") var achive3: Int = 0
    @AppStorage("achive4") var achive4: Int = 0
    @AppStorage("achive5") var achive5: Int = 0
    @AppStorage("level") var level: Int = 1
    
    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if isLandscape {
                    ZStack {
                        
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(.top, 40)
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        NavGuard.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        
                        Image(.stylePlate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 370, height: 320)
                            .padding(.top, 130)
                        
                        
                        VStack {
                            HStack {
                                if achive1 > 20 {
                                    Image(.firstAchiveOpen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image(.firstAchiveClose)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                
                                if achive2 > 50 {
                                    Image(.secondAchiveOpen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image(.secondAchiveClose)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                
                                if level == 10 {
                                    Image(.thirdAchiveOpen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image(.thirdAchiveClose)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                            
                            HStack {
                                if achive4 == 10 {
                                    Image(.fourAchiveOpen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image(.fourAchiveClose)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                
                                if achive5 == 5 {
                                    Image(.fiveAchiveOpen)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image(.fiveAchiveClose)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                            }
                        }
                        .padding(.top, 80)
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundStyle)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )

        }
    }
}





#Preview {
    AchiveView()
}

