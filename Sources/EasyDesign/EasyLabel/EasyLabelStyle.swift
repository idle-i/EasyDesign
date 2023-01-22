//
//  EasyLabelStyle.swift
//
//  Struct containing style properties for the EasyLabel class
//
//  Created by Daniil Shchepkin on 21.01.2023.
//

import UIKit

public struct EasyLabelStyle: EasyViewStyle {
    let font: UIFont?
    let fontSize: CGFloat?
    let textColor: UIColor?
    let textAlignment: NSTextAlignment?
    
    public init(
        font: UIFont? = nil,
        fontSize: CGFloat? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment? = nil
    ) {
        self.font = font
        self.fontSize = fontSize
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
}
