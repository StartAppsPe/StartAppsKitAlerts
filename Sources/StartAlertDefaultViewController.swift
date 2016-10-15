//
//  StartAlertView.swift
//  StartAppsKitLearn
//
//  Created by Gabriel Lanata on 12/9/16.
//  Copyright © 2016 Universidad de Lima. All rights reserved.
//

#if os(iOS)

import UIKit
import StartAppsKitExtensions

open class StartAlertViewButton {
    
    public typealias StartAlertViewButtonAction = (_ alert: StartAlert, _ sender: AnyObject) -> Void
    
    public enum DefaultAction {
        case cancel
        public var action: StartAlertViewButtonAction {
            return { alert, sender in
                alert.dismiss()
            }
        }
    }
    
    public enum Style {
        case normal, destructive
        public var backgroundColor: UIColor {
            switch self {
            case .destructive:
                return UIColor.flatLightRed.with(alpha: 0.7)
            case .normal:
                return UIColor.black.with(alpha: 0.1)
            }
        }
    }
    
    open var title: String
    open var style: Style
    open var action: StartAlertViewButtonAction
    
    public init(title: String, style: Style = .normal, action: @escaping StartAlertViewButtonAction) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    public init(title: String, style: Style = .normal, action defaultAction: DefaultAction) {
        self.title = title
        self.style = style
        self.action = defaultAction.action
    }
    
}

open class StartAlertDefaultViewController: UIViewController, StartAlertPresentable {
    
    public weak var alert: StartAlert!
    
    //public var title: String?
    public var message: String?
    
    public var buttons: [StartAlertViewButton] = []
    
    open override func loadView() {
        super.loadView()
        
        switch alert.style {
        case .top, .bottom, .center, .full:
            view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            let backgroundView = UIVisualEffectView()
            backgroundView.effect = UIBlurEffect(style: .extraLight)
            view.fillWithSubview(backgroundView)
            let vibrancyView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
            vibrancyView.effect = UIVibrancyEffect()
            backgroundView.fillWithSubview(vibrancyView)
        case .navbar, .ticker:
            view.backgroundColor = UINavigationBar.appearance().barTintColor ?? UIColor(white: 0.9686, alpha: 1.0)
        }
        
        let margin: CGFloat
        let topBottomMargin: CGFloat
        let betweenMargin: CGFloat
        switch alert.style {
        case .top, .bottom, .center, .full:
            margin = 15
            topBottomMargin = 25
            betweenMargin = 10
        case .navbar:
            margin = 10
            topBottomMargin = margin
            betweenMargin = margin
        case .ticker:
            margin = 2
            topBottomMargin = margin
            betweenMargin = margin
        }
        
        var topView = view
        
        var headerView: UIView?
        var contentView: UIView?
        var buttonsView: UIView?
        
        if let title = title {
            headerView = UIView()
            guard let headerView = headerView else { return }
            headerView.backgroundColor = UIColor.clear
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
            view.addSubview(headerView)
            
            // Add constraints
            view.addConstraint(
                NSLayoutConstraint(
                    item: headerView, attribute: .top,
                    relatedBy: .equal,
                    toItem: topView, attribute: (topView == view ? .top : .bottom),
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: headerView, attribute: .leading,
                    relatedBy: .equal,
                    toItem: view, attribute: .leading,
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: view, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: headerView, attribute: .trailing,
                    multiplier: 1.0, constant: 0
                )
            )
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh+1, for: .vertical)
            headerView.addSubview(titleLabel)
            
            // Add constraints
            headerView.addConstraint(
                NSLayoutConstraint(
                    item: titleLabel, attribute: .top,
                    relatedBy: .equal,
                    toItem: headerView, attribute: .top,
                    multiplier: 1.0, constant: (topView == view ? topBottomMargin : margin)
                )
            )
            headerView.addConstraint(
                NSLayoutConstraint(
                    item: titleLabel, attribute: .leading,
                    relatedBy: .equal,
                    toItem: headerView, attribute: .leading,
                    multiplier: 1.0, constant: margin
                )
            )
            headerView.addConstraint(
                NSLayoutConstraint(
                    item: headerView, attribute: .bottom,
                    relatedBy: .equal,
                    toItem: titleLabel, attribute: .bottom,
                    multiplier: 1.0, constant: betweenMargin/2.0
                )
            )
            headerView.addConstraint(
                NSLayoutConstraint(
                    item: headerView, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: titleLabel, attribute: .trailing,
                    multiplier: 1.0, constant: margin
                )
            )
            
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            
            topView = headerView
        }
        
        if let message = message {
            contentView = UIView()
            guard let contentView = contentView else { return }
            contentView.backgroundColor = UIColor.clear
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(contentView)
            
            // Add constraints
            view.addConstraint(
                NSLayoutConstraint(
                    item: contentView, attribute: .top,
                    relatedBy: .equal,
                    toItem: topView, attribute: (topView == view ? .top : .bottom),
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: contentView, attribute: .leading,
                    relatedBy: .equal,
                    toItem: view, attribute: .leading,
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: view, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: contentView, attribute: .trailing,
                    multiplier: 1.0, constant: 0
                )
            )
            
            let messageLabel = UILabel()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow-1, for: .vertical)
            contentView.addSubview(messageLabel)
            
            // Add constraints
            contentView.addConstraint(
                NSLayoutConstraint(
                    item: messageLabel, attribute: .top,
                    relatedBy: .equal,
                    toItem: contentView, attribute: .top,
                    multiplier: 1.0, constant: (topView == view ? topBottomMargin : betweenMargin/2.0)
                )
            )
            contentView.addConstraint(
                NSLayoutConstraint(
                    item: messageLabel, attribute: .leading,
                    relatedBy: .equal,
                    toItem: contentView, attribute: .leading,
                    multiplier: 1.0, constant: margin
                )
            )
            contentView.addConstraint(
                NSLayoutConstraint(
                    item: contentView, attribute: .bottom,
                    relatedBy: .equal,
                    toItem: messageLabel, attribute: .bottom,
                    multiplier: 1.0, constant: topBottomMargin
                )
            )
            contentView.addConstraint(
                NSLayoutConstraint(
                    item: contentView, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: messageLabel, attribute: .trailing,
                    multiplier: 1.0, constant: margin
                )
            )
            
            messageLabel.text = message
            
            switch alert.style {
            case .top, .bottom, .center, .full, .navbar:
                messageLabel.font = UIFont.systemFont(ofSize: 16)
            case .ticker:
                messageLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
            topView = contentView
        }
        
        if buttons.count > 0 {
            buttonsView = UIView()
            guard let buttonsView = buttonsView else { return }
            buttonsView.backgroundColor = UIColor.clear
            buttonsView.translatesAutoresizingMaskIntoConstraints = false
            buttonsView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .vertical)
            view.addSubview(buttonsView)
            
            // Add constraints
            view.addConstraint(
                NSLayoutConstraint(
                    item: buttonsView, attribute: .top,
                    relatedBy: .equal,
                    toItem: topView, attribute: (topView == view ? .top : .bottom),
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: buttonsView, attribute: .leading,
                    relatedBy: .equal,
                    toItem: view, attribute: .leading,
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: view, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: buttonsView, attribute: .trailing,
                    multiplier: 1.0, constant: 0
                )
            )
            view.addConstraint(
                NSLayoutConstraint(
                    item: buttonsView, attribute: .height,
                    relatedBy: .greaterThanOrEqual,
                    toItem: nil, attribute: .notAnAttribute,
                    multiplier: 1.0, constant: 50
                )
            )
            
            var leftView: UIView = buttonsView
            for button in buttons {
                
                let buttonButton = UIButton()
                buttonButton.translatesAutoresizingMaskIntoConstraints = false
                buttonsView.fillWithSubview(buttonButton)
                
                // Add constraints
                buttonsView.addConstraint(
                    NSLayoutConstraint(
                        item: buttonButton, attribute: .top,
                        relatedBy: .equal,
                        toItem: buttonsView, attribute: .top,
                        multiplier: 1.0, constant: 0
                    )
                )
                buttonsView.addConstraint(
                    NSLayoutConstraint(
                        item: buttonsView, attribute: .bottom,
                        relatedBy: .equal,
                        toItem: buttonButton, attribute: .bottom,
                        multiplier: 1.0, constant: 0
                    )
                )
                buttonsView.addConstraint(
                    NSLayoutConstraint(
                        item: buttonButton, attribute: .leading,
                        relatedBy: .equal,
                        toItem: leftView, attribute: (leftView == buttonsView ? .leading : .trailing),
                        multiplier: 1.0, constant: (leftView == buttonsView ? 0 : 0.5)
                    )
                )
                if leftView != buttonsView {
                    buttonsView.addConstraint(
                        NSLayoutConstraint(
                            item: buttonButton, attribute: .width,
                            relatedBy: .equal,
                            toItem: leftView, attribute: .width,
                            multiplier: 1.0, constant: 0
                        )
                    )
                }
                
                buttonButton.title = button.title
                buttonButton.setAction({ (sender) in
                    guard let alert = self.alert else { return }
                    button.action(alert, sender)
                })
                buttonButton.titleFont = UIFont.boldSystemFont(ofSize: 16)
                buttonButton.textColor = UIColor.black
                buttonButton.backgroundColor = button.style.backgroundColor
                
                leftView = buttonButton
            }
            
            buttonsView.addConstraint(
                NSLayoutConstraint(
                    item: buttonsView, attribute: .trailing,
                    relatedBy: .equal,
                    toItem: leftView, attribute: .trailing,
                    multiplier: 1.0, constant: 0
                )
            )
            
            topView = buttonsView
        }
        
        
        view.addConstraint(
            NSLayoutConstraint(
                item: view, attribute: .bottom,
                relatedBy: .equal,
                toItem: topView, attribute: .bottom,
                multiplier: 1.0, constant: 0
            )
        )
        
    }
    
}

#endif
