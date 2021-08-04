//
//  AnimatedButton.swift
//  TV shows
//
//  Created by infinum on 04.08.2021..
//

import UIKit

class AnimatedButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.95,y: 0.95)  : .identity
            animate(transform: transform)
        }
    }
}

private extension AnimatedButton {
    
    func animate(transform: CGAffineTransform) {
        UIView.animate (
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 3.0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = transform
            }
        )
    }
}
