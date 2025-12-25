import SwiftUI

struct AppButton: View {
    let title: LocalizedStringKey
    let action: (() -> Void)
    var backgroundColor: Color? = nil
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
        }
        .foregroundColor(backgroundColor == .clear ? .black : .white)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor ?? Color.blue)
        )
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(title: "Test") {
            
        }
    }
}
