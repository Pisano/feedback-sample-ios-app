//
//  MainView.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 20.06.2022.
//

import SwiftUI
import PisanoFeedback

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    private var bounds: CGRect {
        return UIScreen.main.bounds
    }
    
    var body: some View {
        ZStack {
            Image.logo
                .frame(maxHeight: .infinity,
                       alignment: viewModel.isLoaded ? .top : .center)
                .padding(.top)
            
            if viewModel.state != .splash {
                VStack {
                    if case .welcome = viewModel.state {
                        WelcomeView(state: $viewModel.state)
                            .transition(.asymmetric(insertion: AnyTransition.opacity.animation(.easeIn.delay(0.2)),
                                                    removal: .opacity.animation(.linear(duration: 0.01))))
                    }
                    if case .form = viewModel.state {
                        FormView(viewModel: .init())
                            .transition(.asymmetric(insertion: AnyTransition.opacity.animation(.easeIn.delay(0.2)),
                                                    removal: .opacity.animation(.linear(duration: 0.01))))
                    }
                }
                .background(
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(20, corners: .allCorners)
                )
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            BackgroundView()
        )
        .onAppear {
            withAnimation {
                viewModel.isLoaded = true
                viewModel.state = .welcome
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MainView()
        }
    }
}
