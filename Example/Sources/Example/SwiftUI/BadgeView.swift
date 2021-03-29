//
//  BadgeView.swift
//  Example
//
//  Created by june chen on 25/3/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation
import Openpay
import SwiftUI

struct BadgeView: UIViewRepresentable {
    let colorTheme: OpenpayTheme<OpenpayBadge.ColorScheme>

    func makeUIView(context: Context) -> UIView {
        OpenpayBadge(theme: colorTheme)
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
