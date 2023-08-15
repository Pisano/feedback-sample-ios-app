//
//  FormView.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 27.06.2022.
//

import SwiftUI

struct FormView: View {
    @ObservedObject var viewModel: FormViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Group {
                    CustomTextField(title: .name,
                                    placeholder: .name,
                                    icon: Image(systemName: "lock.fill"),
                                    text: $viewModel.fullname)
                    
                    CustomTextField(title: .email,
                                    placeholder: "email@address.com",
                                    icon: Image(systemName: "envelope.fill"),
                                    type: .email,
                                    text: $viewModel.email,
                                    isValid: $viewModel.emailValidation)
                    
                    CustomTextField(title: .phone,
                                    placeholder: "01234567890",
                                    icon: Image(systemName: "phone.fill"),
                                    type: .phone,
                                    text: $viewModel.phone)
                    
                    CustomTextField(title: .externalId,
                                    icon: Image(systemName: "person.wave.2"),
                                    type: .plain,
                                    text: $viewModel.externalId)
                }
                
                Text(viewModel.feedbackCallback.callbackDescription())
                
                AppButton(title: .getFeedback) {
                    viewModel.feedback()
                }
                
                AppButton(title: .clear, action:  {
                    viewModel.clear()
                }, backgroundColor: .clear)
            }
            .padding()
            .padding([.top, .horizontal])
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(viewModel: FormViewModel())
    }
}
