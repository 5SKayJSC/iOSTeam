//
//  HTabItemView.swift
//  BeautifulBarChart
//
//  Created by Quynh Nguyen on 9/13/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit

@objc protocol HTabItemViewDelegate {
    @objc optional func resetAllSelectHTabItemView()
    @objc optional func didSelectHTabItemView(view:HTabItemView)
}

class HTabItemView: UIView {
    var delegate:HTabItemViewDelegate?
    var index: Int = 0
    var fillColor: UIColor = UIColor.darkGray {
        didSet { self.setNeedsDisplay() }
    }
    
    var textColorNormal: UIColor = UIColor.black {
        didSet { self.setNeedsDisplay() }
    }
    
    var textColorActive: UIColor = UIColor.white {
        didSet { self.setNeedsDisplay() }
    }
    
    var imageNormal: UIImage? {
        didSet { self.setNeedsDisplay() }
    }
    
    var imageActive: UIImage? {
        didSet { self.setNeedsDisplay() }
    }
    
    var isSelected: Bool = false {
        didSet { self.setNeedsDisplay() }
    }
    
    var text: String? {
        didSet { self.setNeedsDisplay() }
    }

    override var frame: CGRect {
        didSet { self.setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func draw(_ rect: CGRect) {
        // remove all layer
        if let sublayer = self.layer.sublayers {
            for v in sublayer {
                v.removeFromSuperlayer()
            }
        }
        
        // remove all subview
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        //
        let path_circle = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: rect.size.height/2 + 15),
                                       radius: rect.size.height / 2 + 7,
                                       startAngle: toRadians(CGFloat(180)),
                                       endAngle: toRadians(CGFloat(360)),
                                       clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = path_circle.cgPath
        circleLayer.fillColor = self.fillColor.cgColor
        
        self.layer.addSublayer(circleLayer)
        
        //
        let y: CGFloat = 21
        let rect_1 = CGRect(x: 0, y: y, width: rect.size.width + 0.5, height: rect.size.height - y)
        let path_Triangle = UIBezierPath(rect: rect_1)
        
        let layer = CAShapeLayer()
        layer.path = path_Triangle.cgPath
        layer.fillColor = self.fillColor.cgColor
        self.layer.addSublayer(layer)
        
        //
        let imageView = UIImageView(image: (self.isSelected ? self.imageActive : self.imageNormal))
        imageView.contentMode = .scaleAspectFit
        
        let array = [20, rect.size.height / 2]
        let w_1:CGFloat = array.max()!
        let h_1:CGFloat = array.max()!
        
        let x_1 = (rect.size.width - w_1) / 2
        let y_1 = (rect.size.height - h_1) / 2 
        imageView.frame = CGRect(x: x_1, y: y_1, width: w_1, height: h_1)
        self.layer.addSublayer(imageView.layer)
        
        //
        let y_2 = y_1 + h_1
        let frame_label = CGRect(x: 0, y: y_2, width: rect.size.width, height: rect.size.height - y_2)
        let label = UILabel(frame: frame_label)
        label.textColor = (self.isSelected ? self.textColorActive : self.textColorNormal)
        label.font = UIFont.systemFont(ofSize: 12, weight: 0.15)
        label.text = self.text
        label.textAlignment = .center
        self.addSubview(label)
        //self.layer.addSublayer(label.layer)
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        guard let del = delegate else { return }

        del.resetAllSelectHTabItemView?()
        self.isSelected = true
        del.didSelectHTabItemView?(view: self)
    }

    func toAngle(radians: CGFloat) -> CGFloat {
        return CGFloat(radians * 180 / CGFloat.pi)
    }

    func toRadians(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat.pi / 180
    }

}


