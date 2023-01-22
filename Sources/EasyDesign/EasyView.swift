//
//  EasyView.swift
//  
//
//  Created by Daniil Shchepkin on 22.01.2023.
//

import UIKit

public protocol EasyViewStyle { }

public protocol EasyView: UIView {
    associatedtype Style: EasyViewStyle
    
    init(style: Style)

    func updateStyle(_ style: Style)
    func viewDidSetStyle(_ style: Style)
}

extension EasyView {
    
    public init(style: Style) {
        self.init(frame: .zero)
        
        viewDidSetStyle(style)
    }
    
    public func updateStyle(_ style: Style) {
        viewDidSetStyle(style)
    }
    
    public func viewDidSetStyle(_ style: Style) { }
}
