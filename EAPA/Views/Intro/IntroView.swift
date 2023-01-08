//
//  IntroView.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/06.
//

import SwiftUI

struct IntroView: View {
    
    var body: some View {
        ZStack {
            Color.COLOR_54B6AB
                .ignoresSafeArea()
            
            
            Text("EAPA")
                .foregroundColor(Color.COLOR_FFFFFF)
                .font(.system(size: 100, weight: .heavy))
                .opacity(logoTextOpacity)
                .padding(.bottom, 100)
            
            VStack {
                Spacer()
                Text("JUNU.COM")
                    .foregroundColor(Color.COLOR_FFFFFF)
                    .font(.system(size: 14, weight: .heavy))
                    .opacity(copyrightTextOpacity)
                    .onChange(of: logoTextOpacity) { _ in
                        withAnimation(.easeInOut(duration: 1).delay(2.0)) {
                            copyrightTextOpacity = 1.0
                        }
                    }
            }
            .padding(.bottom, 20)
        }
    }
    
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
