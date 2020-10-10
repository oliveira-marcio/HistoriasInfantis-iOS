//
//  FloatActionButton.swift
//  HistoriasInfantis
//
//  Created by Márcio Oliveira on 10/10/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
class FloatActionButton: UIButton {

    @IBInspectable dynamic var activeColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable dynamic var disabledColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable dynamic var cornerRadius: Float = 0.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(rect: rect)
        (isEnabled ? activeColor : disabledColor)?.setFill()
        path.fill()
    }
}
