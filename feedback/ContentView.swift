//
//  ContentView.swift
//  feedback
//
//  Created by YasinCetin on 28.04.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination:HomeView(),
                               tag: "homeView",
                               selection:$navigationManager.selection) {
                    EmptyView()
                }
                
                SplashView(selection:$navigationManager.selection)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
