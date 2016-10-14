//
//  StartAlertContainerViewController.swift
//  StartAppsKitLearn
//
//  Created by Gabriel Lanata on 12/9/16.
//  Copyright © 2016 Universidad de Lima. All rights reserved.
//

#if os(iOS)

import UIKit

public protocol StartAlertPresentable: class {
    weak var alert: StartAlert! { get set }
}

open class StartAlertContainerViewController: UIViewController {
    
    weak var alert: StartAlert!
    
    var overlayView: UIVisualEffectView!
    var innerView: UIView!
    var innerInnerView: UIView!
    
    var margin: CGFloat {
        if alert.margin != StartAlert.StartAlertDefault {
            return alert.margin
        } else {
            switch alert.style {
            case .top, .bottom: return 5
            case .center: return 30
            case .full: return 20
            case .navbar, .ticker: return 0
            }
        }
    }
    
    var springDamping: CGFloat {
        if alert.springDamping != StartAlert.StartAlertDefault {
            return alert.springDamping
        } else {
            switch alert.style {
            case .top, .bottom: return 0.5
            case .center: return 0.5
            case .full: return 0.5
            case .navbar, .ticker: return 1.0
            }
        }
    }
    
    open override func loadView() {
        super.loadView()
        
        view = UIView()
        view.backgroundColor = UIColor.clear
        
        overlayView = UIVisualEffectView()
        overlayView.backgroundColor = UIColor.clear
        view.fillWithSubview(overlayView)
        
        let vibrancyView = UIVisualEffectView()
        vibrancyView.effect = UIVibrancyEffect()
        vibrancyView.backgroundColor = UIColor.clear
        overlayView.fillWithSubview(vibrancyView)
        
        innerView = UIView()
        innerView.backgroundColor = UIColor.clear
        innerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(innerView)
        
        // Add constraints
        view.addConstraint(
            NSLayoutConstraint(
                item: innerView, attribute: .top,
                relatedBy: .greaterThanOrEqual,
                toItem: view, attribute: .top,
                multiplier: 1.0, constant: margin
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: view, attribute: .bottom,
                relatedBy: .greaterThanOrEqual,
                toItem: innerView, attribute: .bottom,
                multiplier: 1.0, constant: margin
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: innerView, attribute: .leading,
                relatedBy: .greaterThanOrEqual,
                toItem: view, attribute: .leading,
                multiplier: 1.0, constant: margin
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: view, attribute: .trailing,
                relatedBy: .greaterThanOrEqual,
                toItem: innerView, attribute: .trailing,
                multiplier: 1.0, constant: margin
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: view, attribute: .centerX,
                relatedBy: .equal,
                toItem: innerView, attribute: .centerX,
                multiplier: 1.0, constant: 0
            )
        )
        
        view.addConstraint(
            NSLayoutConstraint(
                item: innerView, attribute: .width,
                relatedBy: .lessThanOrEqual,
                toItem: nil, attribute: .notAnAttribute,
                multiplier: 1.0, constant: 400.0
            )
        )
        
        let maximizeWidth = NSLayoutConstraint(
            item: innerView, attribute: .width,
            relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute,
            multiplier: 1.0, constant: 400.0
        )
        maximizeWidth.priority = UILayoutPriorityDefaultHigh+1
        view.addConstraint(maximizeWidth)
        
        switch alert.style {
        case .center:
            view.addConstraint(
                NSLayoutConstraint(
                    item: view, attribute: .centerY,
                    relatedBy: .equal,
                    toItem: innerView, attribute: .centerY,
                    multiplier: 1.0, constant: 0.0
                )
            )
        case .top:
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .top,
                    relatedBy: .equal,
                    toItem: view, attribute: .top,
                    multiplier: 1.0, constant: margin
                )
            )
        case .ticker:
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .top,
                    relatedBy: .equal,
                    toItem: view, attribute: .top,
                    multiplier: 1.0, constant: margin
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .height,
                    relatedBy: .equal,
                    toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: 20.0
                )
            )
        case .navbar:
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .top,
                    relatedBy: .equal,
                    toItem: view, attribute: .top,
                    multiplier: 1.0, constant: margin
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .height,
                    relatedBy: .equal,
                    toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: 64.0
                )
            )
        case .bottom:
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .bottom,
                    relatedBy: .equal,
                    toItem: view, attribute: .bottom,
                    multiplier: 1.0, constant: margin
                )
            )
        case .full:
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .top,
                    relatedBy: .equal,
                    toItem: view, attribute: .top,
                    multiplier: 1.0, constant: margin
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: innerView, attribute: .bottom,
                    relatedBy: .equal,
                    toItem: view, attribute: .bottom,
                    multiplier: 1.0, constant: margin
                )
            )
            
        }
        
        innerInnerView = UIView()
        innerView.fillWithSubview(innerInnerView)
        if let rootViewController = alert.rootViewController as? StartAlertPresentable {
            rootViewController.alert = alert
        }
        insertChild(viewController: alert.rootViewController, inView: innerInnerView)
        
        switch alert.style {
        case .top, .bottom, .center, .full:
            innerInnerView.cornerRadius = 4
            innerView.shadowRadius = 5
            innerView.shadowOpacity = 0.5
        case .navbar, .ticker:
            break
        }
        
        
    }
    
    open func setMoveToHidden() {
        switch alert.animation {
        case .top:
            print("Y = \(innerView.frame.origin.y)")
            print("H = \(innerView.frame.size.height)")
            let transformY = -(innerView.frame.origin.y+innerView.frame.size.height)
            print("T = \(transformY)")
            innerView.transform = CGAffineTransform(translationX: 0, y: transformY)
        case .bottom:
            let transformY = view.frame.size.height-innerView.frame.origin.y
            print("T = \(transformY)")
            innerView.transform = CGAffineTransform(translationX: 0, y: transformY)
        case .zoom:
            innerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        case .none:
            break
        }
    }
    
    open func setStateToHidden() {
        switch alert.animation {
        case .top:
            break
        case .bottom:
            break
        case .zoom:
            innerView.alpha = 0
        case .none:
            break
        }
        view.backgroundColor = UIColor.clear
    }
    
    open func setOverlayToHidden() {
        overlayView.effect = nil
    }
    
    open func setMoveToNormal() {
        innerView.transform = CGAffineTransform.identity
    }
    
    open func setStateToNormal() {
        innerView.alpha = 1
        switch alert.overlay {
        case .blur:
            view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        case .dark:
            view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        case .none:
            break
        }
    }
    
    open func setOverlayToNormal() {
        switch alert.overlay {
        case .blur:
            overlayView.effect = UIBlurEffect(style: .dark)
        case .dark:
            break
        case .none:
            break
        }
    }
    
    open func prepareEntrance(window: UIWindow) {
        switch alert.overlay {
        case .blur, .dark:
            window.isUserInteractionEnabled = true
        case .none:
            window.isUserInteractionEnabled = false
        }
        view.layoutIfNeeded()
        setMoveToHidden()
        setStateToHidden()
        setOverlayToHidden()
    }
    
    open func performEntrance(animated: Bool = true, completion: (() -> Void)?) {
        UIView.animate(
            withDuration: (animated ? 0.5: 0.0),
            delay: 0,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: 0.0,
            options: .curveLinear,
            animations: {
                self.setMoveToNormal()
            },
            completion: { finished in
                completion?()
            }
        )
        UIView.animate(
            withDuration: (animated ? 0.2: 0.0),
            delay: 0,
            options: .curveLinear,
            animations: {
                self.setStateToNormal()
            },
            completion: nil
        )
        UIView.animate(
            withDuration: (animated ? 0.2*4: 0.001*4),
            delay: 0,
            options: .curveLinear,
            animations: {
                self.setOverlayToNormal()
            },
            completion: nil
        )
        overlayView.pauseAnimation(delay: (animated ? 0.2: 0.001))
    }
    
    open func performExit(animated: Bool = true, completion: (() -> Void)?) {
        overlayView.resumeAnimation()
        UIView.animate(
            withDuration: (animated ? 0.2: 0.0),
            delay: 0,
            options: [.curveLinear, .beginFromCurrentState],
            animations: {
                self.setMoveToHidden()
                self.setStateToHidden()
                self.setOverlayToHidden()
            },
            completion: { finished in
                completion?()
            }
        )
    }
    
}

extension UIView {
    
    public func pauseAnimation(delay: Double) {
        let time = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, time, 0, 0, 0, { timer in
            let layer = self.layer
            let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0.0
            layer.timeOffset = pausedTime
        })
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
    }
    
    public func resumeAnimation() {
        let pausedTime  = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
}

#endif
