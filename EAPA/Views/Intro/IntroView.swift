//
//  IntroView.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/06.
//

import SwiftUI

struct IntroView: View {
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.COLOR_54B6AB
                .ignoresSafeArea()
            
            Text("EAPA")
                .foregroundColor(Color.COLOR_FFFFFF)
                .font(.system(size: 100, weight: .heavy))
                .opacity(animate ? 1.0 : 0.0)
                .padding(.bottom, 100)
                .animation(.easeOut(duration: 0.6), value: animate)
            
            VStack {
                Spacer()
                Text("JUNU.COM")
                    .foregroundColor(Color.COLOR_FFFFFF)
                    .font(.system(size: 14, weight: .heavy))
                    .opacity(animate ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 1.0).delay(0.3), value: animate)
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            animate = true
        }
        .onChange(of: animate) { _ in
            // Guide 화면으로 갈지 메인 화면으로 갈지 구분
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                startService()
            }
        }
    }
    
    func startService() {
        print("Start Service")
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
