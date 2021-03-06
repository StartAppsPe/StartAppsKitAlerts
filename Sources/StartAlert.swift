//
//  StartAlert.swift
//  StartAppsKitLearn
//
//  Created by Gabriel Lanata on 12/9/16.
//  Copyright © 2016 Universidad de Lima. All rights reserved.
//

#if os(iOS)
    
    import UIKit
    
    public class StartAlert {
        
        public var alertWindow: UIWindow?
        public static var presentedAlerts: Set<StartAlert> = []
        
        public static let StartAlertDefault: CGFloat = 98765
        
        public var margin: CGFloat = StartAlertDefault
        public var springDamping: CGFloat = StartAlertDefault
        public var autoDismissTime: TimeInterval?
        
        public enum Style {
            case full, top, center, bottom, navbar, ticker
        }
        public var style: Style
        
        public enum Overlay {
            case dark, blur, none
        }
        public var overlay: Overlay
        
        public enum Animation {
            case zoom, top, bottom, none
        }
        public var animation: Animation
        
        public var rootViewController: UIViewController!
        
        public var defaultRootViewController: StartAlertDefaultViewController? {
            return rootViewController as? StartAlertDefaultViewController
        }
        
        public init(style: Style = .ticker, overlay: Overlay = .blur, animation: Animation = .top) {
            self.style = style
            self.overlay = overlay
            self.animation = animation
        }
        
        private var autoDismissTimer: Timer?
        
        public func show(seconds: TimeInterval? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
            guard rootViewController != nil else { print("Alert RootViewController not set"); return }
            guard alertWindow == nil else { return }
            StartAlert.presentedAlerts.insert(self)
            if let seconds = seconds { autoDismissTime = seconds }
            let window = UIApplication.shared.keyWindow!
            alertWindow = UIWindow(frame: window.frame)
            alertWindow!.backgroundColor = UIColor.clear
            alertWindow!.windowLevel = UIWindow.Level.alert
            let newWindowVC = StartAlertContainerViewController()
            newWindowVC.alert = self
            alertWindow!.rootViewController = newWindowVC
            alertWindow!.makeKeyAndVisible()
            newWindowVC.prepareEntrance(window: alertWindow!)
            newWindowVC.performEntrance(animated: animated) {
                if let autoDismissTime = self.autoDismissTime {
                    self.autoDismissTimer = Timer.scheduledTimer(timeInterval: autoDismissTime, repeats: false, actions: { _ in
                        self.dismiss(animated: animated, completion: completion)
                    })
                } else {
                    completion?()
                }
            }
        }
        
        public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
            guard let viewController = alertWindow?.rootViewController as? StartAlertContainerViewController else { return }
            autoDismissTimer?.invalidate()
            viewController.performExit(animated: animated, completion: {
                let window = UIApplication.shared.keyWindow!
                window.makeKeyAndVisible()
                self.alertWindow = nil
                StartAlert.presentedAlerts.remove(self)
                completion?()
            })
        }
        
    }
    
    extension StartAlert: Hashable {
        
        public var hashValue: Int {
            return "\(style)-\(overlay)-\(animation)-\(rootViewController.hashValue)".hashValue
        }
        
        public static func ==(lhs: StartAlert, rhs: StartAlert) -> Bool{
            return lhs.hashValue == rhs.hashValue
        }
        
    }
    
    
    extension Timer {
        
        /********************************************************************************************************/
        // MARK: Closure Methods
        /********************************************************************************************************/
        
        fileprivate typealias TimerCallback = (Timer) -> Void
        
        private class TimerCallbackHolder : NSObject {
            var callback: TimerCallback
            
            init(callback: @escaping TimerCallback) {
                self.callback = callback
            }
            
            @objc func tick(_ timer: Timer) {
                callback(timer)
            }
        }
        
        @discardableResult
        fileprivate convenience init(timeInterval interval: TimeInterval, repeats: Bool, actions: @escaping TimerCallback) {
            #if os(iOS) || os(macOS)
                if #available(iOS 10.0, OSX 10.12, *) {
                    self.init(timeInterval: interval, repeats: repeats, block: actions)
                } else {
                    let holder = TimerCallbackHolder(callback: actions)
                    holder.callback = actions
                    self.init(timeInterval: interval, target: holder, selector: #selector(TimerCallbackHolder.tick(_:)), userInfo: nil, repeats: repeats)
                }
            #else
                self.init(timeInterval: interval, repeats: repeats, block: actions)
            #endif
        }
        
        @discardableResult
        fileprivate class func scheduledTimer(timeInterval interval: TimeInterval, repeats: Bool, actions: @escaping TimerCallback) -> Timer {
            #if os(iOS) || os(macOS)
                if #available(iOS 10.0, OSX 10.12, *) {
                    return self.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: actions)
                } else {
                    let holder = TimerCallbackHolder(callback: actions)
                    holder.callback = actions
                    return self.scheduledTimer(timeInterval: interval, target: holder, selector: #selector(TimerCallbackHolder.tick(_:)), userInfo: nil, repeats: repeats)
                }
            #else
                return self.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: actions)
            #endif
        }
        
    }

    
#endif
