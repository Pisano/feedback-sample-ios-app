import SwiftUI
import PisanoFeedback

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
                
                CustomTextField(title: .title,
                                icon: Image(systemName: "pencil"),
                                text: $viewModel.customTitle)

                Text(LocalizedStringKey.font)
                Picker(.font, selection: $viewModel.selectedFont) {
                    ForEach(viewModel.fonts, id: \.self) { font in
                        Text(font.value)
                    }
                }
                .pickerStyle(.automatic)

                Text("Custom Title Color")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.colors, id: \.self) { color in
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color)
                                .frame(width: 40, height: 50)
                                .onTapGesture {
                                    viewModel.selectedColor = color
                                }
                                .opacity(viewModel.selectedColor == color ? 0.2 : 1)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .hide(viewModel.selectedColor != color)
                                )
                        }
                    }
                }

                Text("View Mode")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.modes, id: \.self) { mode in
                            AppButton(title: mode.title, action:  {
                                viewModel.selectedMode = mode
                            }, backgroundColor: viewModel.selectedMode == mode ? .blue : .clear)
                        }
                    }
                }
                
                Text(.actionStatus)
                Text(viewModel.sdkCallback.description)
                Text(viewModel.preflightStatus)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
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
