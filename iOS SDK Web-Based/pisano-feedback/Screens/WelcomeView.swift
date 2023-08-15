//
//  WelcomeView.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 20.06.2022.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var state: AppState
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Feedback")
                .font(.title)
                .bold()
                .padding(.top)
            
            Text("forms \\ flows")
                .foregroundColor(.blue)
                .font(.largeTitle)
                .bold()
            
            Text("for business")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            AppButton(title: .gettingStarted) {
                withAnimation {
                    state = .form
                }
            }
            .padding(.bottom)
            
            Text("Interact with flows made by Pisano")
                .font(.subheadline)
                .fontWeight(.ultraLight)
                .padding(.bottom)
        }
        .padding()
        .padding(.horizontal)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(state: .constant(.welcome))
    }
}
