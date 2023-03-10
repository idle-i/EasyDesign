//
//  EasyButton.swift
//
//  A class that represents a custom implementation of the UIButton class from UIKit
//
//  Created by Daniil Shchepkin on 22.01.2023.
//

import UIKit

public enum EasyButtonVibrationIntensity {
    case light
    case medium
    case heavy
}

@IBDesignable
public class EasyButton: UIButton, EasyView {
    
    // MARK: - Public Variables

    public override var isEnabled: Bool {
        didSet { self.updateView() }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            self.viewDidHighlight()
            
            self.updateView()
        }
    }
    
    public var isZoomEnabled: Bool = false
    public var zoomFactor: CGFloat = 1.0
    public var zoomDuration: Double = 0.3
    
    public var isVibrationEnabled: Bool = false
    public var vibrationIntensity: EasyButtonVibrationIntensity = .light
    
    // MARK: - Private Variables
    
    private var style: EasyButtonStyle = EasyButtonStyle()
    
    private var clickHandler: (() -> Void)?
    
    // MARK: - Initializers
    
    public convenience init(text: String) {
        self.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTapHandler()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.addTapHandler()
    }
    
    // MARK: - Public Methods
    
    public func setClickHandler(_ clickHandler: @escaping () -> Void) {
        self.clickHandler = clickHandler
    }
    
    public func removeClickHandler() {
        self.clickHandler = nil
    }
    
    public func viewDidSetStyle(_ style: EasyButtonStyle) {
        if let cornerRaduis = style.cornerRaduis, self.layer.cornerRadius != cornerRaduis {
            self.layer.cornerRadius = cornerRaduis
        }
        
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
        
        self.updateView()
    }
    
    // MARK: - Private Methods
    
    private func addTapHandler() {
        self.addTarget(
            self,
            action: #selector(tapActionHandle),
            for: .touchUpInside
        )
    }
    
    private func updateView() {
        self.tintColor =
            (!self.isEnabled) ? self.style.tintColorDisabled :
            (self.isHighlighted) ? self.style.tintColorSelected :
            self.style.tintColor
        
        self.backgroundColor =
            (!self.isEnabled) ? self.style.backgroundColorDisabled :
            (self.isHighlighted) ? self.style.backgroundColorSelected :
            self.style.backgroundColor
        
        self.setTitleColor(self.style.textColor, for: .normal)
        self.setTitleColor(self.style.textColorSelected, for: .highlighted)
        self.setTitleColor(self.style.textColorDisabled, for: .disabled)
    }
    
    private func viewDidHighlight() {
        if self.isZoomEnabled { self.zoomAnimation() }
    }
    
    private func zoomAnimation() {
        UIView.animate(withDuration: self.zoomDuration) { [weak self] in
            guard let self = self else { return }
            
            self.transform = CGAffineTransform(
                scaleX: self.isHighlighted ? self.zoomFactor : 1.0,
                y: self.isHighlighted ? self.zoomFactor : 1.0
            )
        }
    }
    
    private func performVibration() {
        let generator = UIImpactFeedbackGenerator(
            style:
                (self.vibrationIntensity == .light) ? .light :
                (self.vibrationIntensity == .medium) ? .medium :
                .heavy
        )
        generator.prepare()
        generator.impactOccurred()
    }
    
    // MARK: - Callbacks
    
    @objc private func tapActionHandle() {
        if self.isVibrationEnabled { self.performVibration() }
        
        self.clickHandler?()
    }
}

