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
    
    // MARK: - Public Variables
    
    public var isLinksEnabled: Bool = false {
        didSet { self.layoutIfNeeded() }
    }
    public var linkClickHandler: ((_ url: URL) -> Void)?

    // MARK: - Private Variables
    
    private var clickHandler: (() -> Void)? {
        didSet { self.updateGestureRecognizer() }
    }
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    private var links = [URL: NSRange]()
    private var linksColor: UIColor = UIColor.link
    
    // MARK: - Initializers
    
    public convenience init(text: String) {
        self.init(frame: .zero)
        
        self.text = text
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Lifecycle Methods
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isLinksEnabled { self.findLinks() }
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
        
        if let linksColor = style.linksColor, self.linksColor != linksColor {
            self.linksColor = linksColor
        }
    }
    
    // MARK: - Private Methods
    
    private func updateGestureRecognizer() {
        if self.clickHandler != nil {
            self.tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(self.tapActionHandle(_:))
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
    
    @objc private func tapActionHandle(_ gesture: UITapGestureRecognizer) {
        if isLinksEnabled {
            self.getClickedLink(gesture: gesture) { url in
                if let url = url {
                    self.linkClickHandler?(url)
                } else {
                    self.clickHandler?()
                }
            }
        } else { self.clickHandler?() }
    }
}

// MARK: - Links Extension

extension EasyLabel {
    
    private func findLinks() {
        if let text = self.text {
            let mutableAttributedString = NSMutableAttributedString(string: text)
            
            getUrlList(from: text).forEach { url in
                let range = (text as NSString).range(of: url.absoluteString)
                
                links[url] = range
                
                mutableAttributedString.addAttribute(.foregroundColor, value: self.linksColor, range: range)
            }
            
            self.attributedText = mutableAttributedString
        }
    }
    
    private func getUrlList(from string: String) -> [URL] {
        let type = NSTextCheckingResult.CheckingType.link
        
        do {
            return try NSDataDetector(types: type.rawValue)
                .matches(in: string, range: NSMakeRange(0, string.count))
                .compactMap { $0.url }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return []
    }
    
    private func getClickedLink(gesture: UITapGestureRecognizer, completion: (_ url: URL?) -> Void) {
        guard let attributedText = self.attributedText else { return completion(nil) }
        
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = gesture.location(in: self)
        let textBounds = layoutManager.usedRect(for: textContainer)
        let alignmentOffset = self.aligmentOffset(for: self.textAlignment)
        
        let offsetX = ((self.bounds.size.width - textBounds.size.width) * alignmentOffset) - textBounds.origin.x
        let offsetY = ((self.bounds.size.height - textBounds.size.height) * alignmentOffset) - textBounds.origin.y
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - offsetX,
            y: locationOfTouchInLabel.y - offsetY
        )
        
        let characterTapped = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        let charsInLineTapped = layoutManager.characterIndex(
            for: CGPoint(
                x: self.bounds.size.width,
                y: self.font.lineHeight * CGFloat(Int(ceil(locationOfTouchInLabel.y / self.font.lineHeight)) - 1)
            ),
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        if characterTapped < charsInLineTapped {
            for (url, range) in self.links {
                if range.contains(characterTapped) {
                    completion(url)
                    
                    return
                }
            }
        }
        
        completion(nil)
    }
    
    private func aligmentOffset(for alignment: NSTextAlignment) -> CGFloat {
        switch alignment {
        case .right: return 1.0
        case .center: return 0.5
        default: return 0.0
        }
    }
}
