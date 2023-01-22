//
//  EasyLabel.swift
//
//  A class that represents a custom implementation of the UILabel class from UIKit
//
//  Created by Daniil Shchepkin on 21.01.2023.
//

import UIKit

@IBDesignable
public class EasyLabel: UILabel, EasyView {

    // MARK: - Private Variables
    
    private var clickHandler: (() -> Void)? {
        didSet { self.updateGestureRecognizer() }
    }
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    // MARK: - Initializers
    
    public convenience init(text: String) {
        self.init(frame: .zero)
        
        self.text = text
    }
    
    // MARK: - Public Methods
    
    public func setClickHandler(_ clickHandler: @escaping () -> Void) {
        self.clickHandler = clickHandler
    }
    
    public func removeClickHandler() {
        self.clickHandler = nil
    }
    
    public func viewDidSetStyle(_ style: EasyLabelStyle) {
        if let font = style.font, self.font != font {
            self.font = font
        }
        
        if let fontSize = style.fontSize {
            self.font = self.font.withSize(fontSize)
        }
        
        if let textColor = style.textColor, self.textColor != textColor {
            self.textColor = textColor
        }
        
        if let textAlignment = style.textAlignment, self.textAlignment != textAlignment {
            self.textAlignment = textAlignment
        }
    }
    
    // MARK: - Private Methods
    
    private func updateGestureRecognizer() {
        isUserInteractionEnabled = self.clickHandler != nil
        
        if self.clickHandler != nil {
            self.tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapActionHandle)
            )
            
            addGestureRecognizer(self.tapGestureRecognizer!)
        } else {
            if let tapGestureRecognizer = self.tapGestureRecognizer {
                removeGestureRecognizer(tapGestureRecognizer)
            }
            
            self.tapGestureRecognizer = nil
        }
    }
    
    // MARK: - Callbacks
    
    @objc private func tapActionHandle() { self.clickHandler?() }
}
