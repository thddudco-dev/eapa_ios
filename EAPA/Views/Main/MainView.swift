//
//  MainView.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/06.
//

import SwiftUI

struct MainView: View {
    
    @State private var path = NavigationPath()
    
    @State var presentingModal = false
    @State var presentingGuide = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    ForEach(0..<10) { idx in
                        NavigationLink("idx : \(idx)", value: idx)
                    }
                }
                .navigationTitle("Main")
                .navigationDestination(for: Int.self) { item in
                    HistoryView()
                }
                
                Spacer()
                
                Button {
                    path.append("UserView")
                } label: {
                    Text("Navigation UserView")
                }
                .padding()
                .navigationDestination(for: String.self) { view in
                    if view == "UserView" {
                        UserView()
                    }
                }
                
                Button {
                    presentingModal.toggle()
                } label: {
                    Text("Presnt View")
                }
                .padding()
                .fullScreenCover(isPresented: $presentingModal) {
                    HistoryView()
                }
//                .sheet(isPresented: $presentingModal) {
//                    HistoryView()
//                }
            }
        }
        .onAppear {
            presentingGuide.toggle()
        }
        .fullScreenCover(isPresented: $presentingGuide) {
            GuideView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
