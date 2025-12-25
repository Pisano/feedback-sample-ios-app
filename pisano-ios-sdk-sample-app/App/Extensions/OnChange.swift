//
//  File.swift
//  
//
//  Created by Abdulkerim Şahin on 3.06.2022.
//

import SwiftUI
import Combine

extension View {
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}
