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
        var scrollView: UIScrollView!
        var scrollInnerView: UIView!
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
            
            self.view = UIView()
            self.view.backgroundColor = UIColor.clear
            
            overlayView = UIVisualEffectView()
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            overlayView.backgroundColor = UIColor.clear
            self.view.fillWithSubview(overlayView)
            
            let vibrancyView = UIVisualEffectView()
            vibrancyView.translatesAutoresizingMaskIntoConstraints = false
            vibrancyView.effect = UIVibrancyEffect()
            vibrancyView.backgroundColor = UIColor.clear
            overlayView.fillWithSubview(vibrancyView)
            
            scrollView = UIScrollView()
            scrollView.backgroundColor = UIColor.clear
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.view.fillWithSubview(scrollView)
            
            scrollInnerView = UIView()
            scrollInnerView.backgroundColor = UIColor.clear
            scrollInnerView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.fillWithSubview(scrollInnerView)
            
            scrollView.addConstraint(
                NSLayoutConstraint(
                    item: scrollInnerView, attribute: .width,
                    relatedBy: .equal,
                    toItem: scrollView, attribute: .width,
                    multiplier: 1.0, constant: 0.0
                )
            )
            
            scrollView.addConstraint(
                NSLayoutConstraint(
                    item: scrollInnerView, attribute: .height,
                    relatedBy: .equal,
                    toItem: scrollView, attribute: .height,
                    multiplier: 1.0, constant: 0.0
                )
            )
            
            let view = scrollInnerView!
            
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
            maximizeWidth.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(Int(UILayoutPriority.defaultHigh.rawValue)+1))
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
                innerInnerView.layer.cornerRadius = 4
                innerInnerView.layer.masksToBounds = true
                innerView.layer.shadowRadius = 5
                innerView.layer.shadowOpacity = 0.5
            case .navbar, .ticker:
                break
            }
            
            
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            //Register for Notifications
            NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) { (notification) -> Void in
                self.keyboardShownChanged(show: true,  userInfo: (notification as NSNotification).userInfo)
            }
            NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) { (notification) -> Void in
                self.keyboardShownChanged(show: false, userInfo: (notification as NSNotification).userInfo)
            }
        }
        
        func keyboardShownChanged(show: Bool, userInfo: [AnyHashable: Any]?) {
            let keyboardHeight       = (show ? ((userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size.height) : 0)
            let animationDuration    = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
            var options = UIViewAnimationOptions()
            if let animationCurveRaw = (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue {
                options = UIViewAnimationOptions(rawValue: UInt(animationCurveRaw << 16))
            }
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: keyboardHeight/2), animated: false)
            }, completion: nil)
        }
        
        open func setMoveToHidden() {
            switch alert.animation {
            case .top:
                let transformY = -(innerView.frame.origin.y+innerView.frame.size.height)
                innerView.transform = CGAffineTransform(translationX: 0, y: transformY)
            case .bottom:
                let transformY = view.frame.size.height-innerView.frame.origin.y
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
    
    
    
    
    
    internal extension UIViewController {
        
        internal func insertChild(viewController: UIViewController, inView: UIView) {
            addChildViewController(viewController)
            viewController.willMove(toParentViewController: self)
            inView.fillWithSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
        
        internal func removeChild(viewController: UIViewController) {
            viewController.removeFromParentViewController()
            viewController.willMove(toParentViewController: nil)
            viewController.view?.removeFromSuperview()
            viewController.didMove(toParentViewController: nil)
        }
        
    }
    
    
    internal extension UIView {
        
        internal func fillWithSubview(_ view: UIView, margin: CGFloat = 0.0) {
            
            // Add view
            view.translatesAutoresizingMaskIntoConstraints = false
            var newFrame = view.frame
            newFrame.size.width = self.bounds.width
            view.layoutIfNeeded()
            view.updateConstraintsIfNeeded()
            view.frame = newFrame
            self.addSubview(view)
            
            // Add constraints
            self.addConstraint(
                NSLayoutConstraint(item: view,
                                   attribute: .top, relatedBy: .equal,
                                   toItem: self, attribute: .top,
                                   multiplier: 1.0, constant: margin
                )
            )
            self.addConstraint(
                NSLayoutConstraint(item: view,
                                   attribute: .leading, relatedBy: .equal,
                                   toItem: self, attribute: .leading,
                                   multiplier: 1.0, constant: margin
                )
            )
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .bottom, relatedBy: .equal,
                                   toItem: view, attribute: .bottom,
                                   multiplier: 1.0, constant: margin
                )
            )
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .trailing, relatedBy: .equal,
                                   toItem: view, attribute: .trailing,
                                   multiplier: 1.0, constant: margin
                )
            )
            
        }
        
    }
    
#endif
