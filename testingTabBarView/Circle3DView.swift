//
//  Circle3DView.swift
//  testingTabBarView
//
//  Created by Nick on 04/03/18.
//  Copyright © 2018 Nick. All rights reserved.
//

let CIRCLE_RADIUS:CGFloat = 250

import UIKit

protocol Circle3DViewDelegate: NSObjectProtocol {
    func selectedValue(index:Int)
}

class Circle3DView: UIView {
    
    var menuTitleValues = [String]()
    var currentIndex = -1
    var itemPathArray = [UIBezierPath]()
    var menuImageArray = [UIImageView]()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        label.sizeToFit()
        return label
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    weak var delegate: Circle3DViewDelegate?
    
    public init(frame: CGRect, values:[String]) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureForCircle))
        addGestureRecognizer(panGesture)
        backgroundColor = UIColor(red: 45/255, green: 62/255, blue: 79/255, alpha: 1.0)
        layer.cornerRadius = CIRCLE_RADIUS/2
        layer.shadowOpacity = 0.7
        layer.shadowOffset  = CGSize(width: 0, height: -2)
        menuTitleValues = values
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let menuCount = Float(menuTitleValues.count)
        let initalTh = Float.pi / Float(((menuCount - 1) * 2 + 2));
        let th = (.pi - 2 * initalTh) / Float((menuCount - 1))
        
        for index in 0..<Int(menuCount) {
            let radius = ((bounds.width / 2) * 0.75)
            let imageView = UIImageView()
            imageView.image = UIImage(named:String(menuTitleValues[index]))
            addSubview(imageView)
            imageView.transform = .identity
            imageView.center = CGPoint(x: bounds.width / 2, y: bounds.width / 2)
            imageView.bounds = CGRect(x: 0, y: 0, width: 35, height: 35)
            let revolve = initalTh + (th * Float(index))
            let yTranslate = CGFloat(sin(revolve)) * radius
            let xTranslate = CGFloat(cos(revolve)) * radius
            imageView.transform = CGAffineTransform(translationX: -xTranslate, y: -yTranslate)
            menuImageArray.append(imageView)
        }
        
        let centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = bounds.width / 2
        let touchTh = CGFloat(.pi / menuCount)
        for index in 0..<Int(menuCount) {
            let path = UIBezierPath()
            path.move(to: centerPoint)
            let startAngle: CGFloat = .pi + CGFloat(index) * touchTh
            let endAngle: CGFloat = .pi + CGFloat(index + 1) * touchTh
            path.addArc(withCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            itemPathArray.append(path)
        }
        
        let iconImageView = UIImageView(image: UIImage(named:"selected"))
        iconImageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        iconImageView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        addSubview(iconImageView)
        
        titleLabel.center = CGPoint(x: iconImageView.center.x, y: -30)
        titleLabel.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: 30)
        addSubview(titleLabel)
        
    }
    
    open func show(in view : UIView){
        
        visualEffectView.frame = view.bounds
        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(self)
        
        frame = CGRect(x: view.bounds.midX - CIRCLE_RADIUS/2, y: view.bounds.height - CIRCLE_RADIUS/2 - 25, width: CIRCLE_RADIUS, height: CIRCLE_RADIUS)
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 20, options: .curveEaseIn, animations: {
            self.transform = .identity
        }, completion: nil)
        
    }
    
    open func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        },completion: { (status) in
            self.transform = .identity
            self.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        })
    }
    
    func animateMenuItems(){
        
    }
    
    @objc open func panGestureForCircle(pan: UIGestureRecognizer) {
        
        let touchPoint: CGPoint = pan.location(in: self)
        switch pan.state {
        case .changed:
            let xFactor: CGFloat = min(1, max(-1, (touchPoint.x - (bounds.size.width / 2)) / (bounds.size.width / 2)))
            let yFactor: CGFloat = min(1, max(-1, (touchPoint.y - (bounds.size.height / 2)) / (bounds.size.height / 2)))
            layer.transform = transform3DView(withM34: 1.0 / -500, xf: xFactor, yf: yFactor)
            
            currentIndex = -1
            for (intex,value) in itemPathArray.enumerated(){
                if value.contains(touchPoint){
                    currentIndex = intex
                    continue
                }
            }
            if (currentIndex >= 0 && currentIndex < menuTitleValues.count) {
                titleLabel.text = menuTitleValues[currentIndex]
                _ = menuImageArray[currentIndex]
            }
            
            if (currentIndex < 0) {
                titleLabel.text = "Menu";
                currentIndex = -1
            }
            
        case .ended, .failed, .cancelled:
            UIView.animate(withDuration: 0.3, animations: {
                self.layer.transform = self.transform3DView(withM34: 1.0 / -500, xf: 0, yf: 0)
            })
            
            if(currentIndex > 0){
                delegate?.selectedValue(index: currentIndex)
            }
        default:
            break
        }
    }
    
    func transform3DView(withM34 m34: CGFloat, xf: CGFloat, yf: CGFloat) -> CATransform3D {
        var t: CATransform3D = CATransform3DIdentity
        t.m34 = m34
        t = CATransform3DRotate(t, .pi / 9 * yf, -1, 0, 0)
        t = CATransform3DRotate(t, .pi / 9 * xf, 0, 1, 0)
        return t
    }
}
