//
//  EasyButton.swift
//  
//
//  Created by Daniil Shchepkin on 22.01.2023.
//

import UIKit

@IBDesignable
public class EasyButton: UIButton, EasyView {
    
    // MARK: - Public Variables

    public override var isEnabled: Bool {
        didSet { self.updateView() }
    }
    
    public override var isHighlighted: Bool {
        didSet { self.updateView() }
    }
    
    // MARK: - Private Variables
    
    private var style: EasyButtonStyle = EasyButtonStyle()
    
    private var clickHandler: (() -> Void)?
    
    // MARK: - Initializers
    
    public convenience init(text: String) {
        self.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
    }
    
    // MARK: - Public Methods
    
    public func setClickHandler(_ clickHandler: @escaping () -> Void) {
        self.clickHandler = clickHandler
    }
    
    public func removeClickHandler() {
        self.clickHandler = nil
    }
    
    // MARK: - Private Methods
    
    internal func viewDidSetStyle(_ style: EasyButtonStyle) {
        if let tintColor = style.tintColor {
            self.style.tintColor = tintColor
        }
        
        if let tintColorDisabled = style.tintColorDisabled {
            self.style.tintColorDisabled = tintColorDisabled
        }
        
        if let tintColorSelected = style.tintColorSelected {
            self.style.tintColorSelected = tintColorSelected
        }
        
        if let backgroundColor = style.backgroundColor {
            self.style.backgroundColor = backgroundColor
        }
        
        if let backgroundColorDisabled = style.backgroundColorDisabled {
            self.style.backgroundColorDisabled = backgroundColorDisabled
        }
        
        if let backgroundColorSelected = style.backgroundColorSelected {
            self.style.backgroundColorSelected = backgroundColorSelected
        }
        
        if let font = style.font, let titleLabel = self.titleLabel, titleLabel.font != font {
            titleLabel.font = font
        }
        
        if let fontSize = style.fontSize, let titleLabel = self.titleLabel {
            titleLabel.font = titleLabel.font.withSize(fontSize)
        }
        
        if let textColor = style.textColor {
            self.style.textColor = textColor
        }
        
        if let textColorDisabled = style.textColorDisabled {
            self.style.textColorDisabled = textColorDisabled
        }
        
        if let textColorSelected = style.textColorSelected {
            self.style.textColorSelected = textColorSelected
        }
        
        if let verticalAlignment = style.verticalAlignment, self.contentVerticalAlignment != verticalAlignment {
            self.contentVerticalAlignment = verticalAlignment
        }
        
        if let horizontalAlignment = style.horizontalAlignment, self.contentHorizontalAlignment != horizontalAlignment {
            self.contentHorizontalAlignment = horizontalAlignment
        }
        
        updateView()
    }
    
    private func updateView() {
        self.tintColor =
            (!isEnabled) ? style.tintColorDisabled :
            (isHighlighted) ? style.tintColorSelected :
            style.tintColor
        
        self.backgroundColor =
            (!isEnabled) ? style.backgroundColorDisabled :
            (isHighlighted) ? style.backgroundColorSelected :
            style.backgroundColor
        
        self.setTitleColor(
            (!isEnabled) ? style.textColorDisabled :
            (isHighlighted) ? style.textColorSelected :
            style.textColor,
            for: .normal
        )
    }
}
