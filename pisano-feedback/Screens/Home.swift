//
//  Home.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

struct Home: View {
    @ObservedObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            Image("PisanoLogo")
                .frame(maxHeight: .infinity,
                       alignment: viewModel.state == .splash ? .center : .top)
            
            VStack(alignment: .leading) {
                CustomTextField(title: .name,
                                placeholder: .name,
                                icon: Image(systemName: "lock.fill"),
                                text: $viewModel.fullname)
                
                CustomTextField(title: .email,
                                placeholder: "emailaddress@pisano.com",
                                icon: Image(systemName: "envelope.fill"),
                                type: .email,
                                isRequired: true,
                                text: $viewModel.email,
                                isValid: $viewModel.emailValidation)
                
                CustomTextField(title: .phone,
                                placeholder: "01234567890",
                                icon: Image(systemName: "phone.fill"),
                                type: .phone,
                                text: $viewModel.phone)
                
                Text("Action Status: \(viewModel.sdkCallback.description)")
                
                Spacer()
                
                Button {
                    viewModel.feedback()
                } label: {
                    Text(.getFeedback)
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                }
                .background(Color.tint)
            }
            .padding()
            .padding(.top, 60)
            .background(
                Rectangle()
                    .fill(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.top, 60)
            )
            .offset(x: 0, y: viewModel.state == .splash ? .screenHeight : 0)
        }
        .background(
            BackgroundView()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                withAnimation(.easeOut) {
                    viewModel.state = .home
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
