//
//  EasyButtonStyle.swift
//  
//
//  Created by Daniil Shchepkin on 22.01.2023.
//

import UIKit

public struct EasyButtonStyle: EasyViewStyle {
    let cornerRaduis: CGFloat?
    var tintColor: UIColor?
    var tintColorDisabled: UIColor?
    var tintColorSelected: UIColor?
    var backgroundColor: UIColor?
    var backgroundColorDisabled: UIColor?
    var backgroundColorSelected: UIColor?
    let font: UIFont?
    let fontSize: CGFloat?
    var textColor: UIColor?
    var textColorDisabled: UIColor?
    var textColorSelected: UIColor?
    let verticalAlignment: UIControl.ContentVerticalAlignment?
    let horizontalAlignment: UIControl.ContentHorizontalAlignment?
    
    public init(
        cornerRaduis: CGFloat? = nil,
        tintColor: UIColor? = nil,
        tintColorDisabled: UIColor? = nil,
        tintColorSelected: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        backgroundColorDisabled: UIColor? = nil,
        backgroundColorSelected: UIColor? = nil,
        font: UIFont? = nil,
        fontSize: CGFloat? = nil,
        textColor: UIColor? = nil,
        textColorDisabled: UIColor? = nil,
        textColorSelected: UIColor? = nil,
        verticalAlignment: UIControl.ContentVerticalAlignment? = nil,
        horizontalAlignment: UIControl.ContentHorizontalAlignment? = nil
    ) {
        self.cornerRaduis = cornerRaduis
        self.tintColor = tintColor
        self.tintColorDisabled = tintColorDisabled
        self.tintColorSelected = tintColorSelected
        self.backgroundColor = backgroundColor
        self.backgroundColorDisabled = backgroundColorDisabled
        self.backgroundColorSelected = backgroundColorSelected
        self.font = font
        self.fontSize = fontSize
        self.textColor = textColor
        self.textColorDisabled = textColorDisabled
        self.textColorSelected = textColorSelected
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
    }
}
