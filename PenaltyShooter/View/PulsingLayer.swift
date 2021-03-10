//
//  PulsingLayer.swift
//  PenaltyShooter
//
//  Created by Branislav on 18/02/2021.
//

import UIKit

class PulsingLayer: CALayer {
    
    private var animationGroup = CAAnimationGroup()
    private var endPulseRadius: CGFloat?
    private let animationDuration: TimeInterval = 0.8
    private var radius: CGFloat?
    private var numberOfPulses: Float = Float.infinity
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // We're not using storyboards
        return nil
    }
    
    init (radius: CGFloat, position: CGPoint, endPulseRadius: CGFloat) {
        super.init()
        borderColor = UIColor.purple.cgColor
        contentsScale = UIScreen.main.scale
        opacity = 0.5
        self.radius = radius
        numberOfPulses = Float.infinity
        self.endPulseRadius = endPulseRadius
        self.position = position
        
        bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        cornerRadius = radius
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimatiomnGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    func creatScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.27
        scaleAnimation.duration = animationDuration
        scaleAnimation.speed = 0.85
        return scaleAnimation
    }
    
    func createBorderColorAnimation () -> CAKeyframeAnimation {
        let colorAnimation = CAKeyframeAnimation(keyPath: "borderColor")
        colorAnimation.duration = animationDuration
        colorAnimation.calculationMode = .discrete
        colorAnimation.values = [UIColor.penaltyPurple.cgColor, UIColor.penaltyPurpleBlue.cgColor]
        colorAnimation.keyTimes = [0, NSNumber(value: animationDuration / 2 ), NSNumber(value: animationDuration)]
        borderWidth = 2
        add(colorAnimation, forKey: "borderColor")
        return colorAnimation
    }
    
    func createBackgroundColorAnimation () -> CAKeyframeAnimation {
        let colorAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = animationDuration
        colorAnimation.calculationMode = .discrete
        colorAnimation.values = [UIColor.penaltyPurple.withAlphaComponent(0.5).cgColor, UIColor.penaltyPurpleBlue.withAlphaComponent(0.5).cgColor]
        colorAnimation.keyTimes = [0, NSNumber(value: animationDuration / 2 ), NSNumber(value: animationDuration)]
        add(colorAnimation, forKey: "backgroundColor")
        return colorAnimation
    }
    
    func setupAnimatiomnGroup() {
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration
        animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animationGroup.timingFunction = defaultCurve
        
        animationGroup.animations = [creatScaleAnimation(), createBackgroundColorAnimation(), createBorderColorAnimation()]
    }
    
    func pauseAnimation() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = self.timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}
