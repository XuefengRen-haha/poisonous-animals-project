

import Foundation
import UIKit

/**
 The bounding box that surrounding spiders during prediction,
 which are captured by object detector
 */
class BoundingBoxView {
    let shapeLayer: CAShapeLayer
    let textLayer: CATextLayer
    
    // initial the shape layer and text layer
    init() {
        shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.isHidden = true
        
        textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.isHidden = true
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.fontSize = 14
        textLayer.font = UIFont(name: "Avenir", size: textLayer.fontSize)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
    }
    
    /**
     Add the shape layer and text layer to current layer
     - parameter parent: current layer
     */
    func addToLayer(_ parent: CALayer) {
        parent.addSublayer(shapeLayer)
        parent.addSublayer(textLayer)
    }
    
    /**
     Present the shape layer and text layer
     - parameter frame: size, position of the bounding box
     - parameter label: prediction result
     - parameter color: color of the bounding box
     */
    func show(frame: CGRect, label: String, color: UIColor) {
        CATransaction.setDisableActions(true)
        
        let path = UIBezierPath(rect: frame)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.isHidden = false
        
        textLayer.string = label
        textLayer.backgroundColor = color.cgColor
        textLayer.isHidden = false
        
        let attributes = [
            NSAttributedString.Key.font: textLayer.font as Any
        ]
        
        let textRect = label.boundingRect(with: CGSize(width: 400, height: 100),
                                          options: .truncatesLastVisibleLine,
                                          attributes: attributes, context: nil)
        let textSize = CGSize(width: textRect.width + 12, height: textRect.height)
        let textOrigin = CGPoint(x: frame.origin.x - 2, y: frame.origin.y - textSize.height)
        textLayer.frame = CGRect(origin: textOrigin, size: textSize)
    }
    
    /** Hide bounding boxes */
    func hide() {
        shapeLayer.isHidden = true
        textLayer.isHidden = true
    }
}
