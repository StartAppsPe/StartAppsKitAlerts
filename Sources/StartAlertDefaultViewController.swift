//
//  StartAlertView.swift
//  StartAppsKitLearn
//
//  Created by Gabriel Lanata on 12/9/16.
//  Copyright © 2016 Universidad de Lima. All rights reserved.
//

#if os(iOS)
    
    import UIKit
    
    open class StartAlertViewButton {
        
        public static var highlightedColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        public static var destructiveColor: UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.70)
        public static var normalColor: UIColor      = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        public typealias StartAlertViewButtonAction = (_ alert: StartAlert, _ sender: Any) -> Void
        
        public enum DefaultAction {
            case cancel
            public var action: StartAlertViewButtonAction {
                return { alert, sender in
                    alert.dismiss()
                }
            }
        }
        
        public enum Style {
            case normal, destructive, highlighted
            public var backgroundColor: UIColor {
                switch self {
                case .highlighted:
                    return highlightedColor
                case .destructive:
                    return destructiveColor
                case .normal:
                    return normalColor
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
    
    open class StartAlertViewInput {
        
        public typealias StartAlertViewInputCustomize = (_ input: UIControl) -> Void
        
        public enum Style {
            case textField
        }
        
        open var title: String
        open var style: Style
        open var customize: StartAlertViewInputCustomize?
        
        open var view: UIControl?
        
        public init(title: String, style: Style = .textField, customize: StartAlertViewInputCustomize? = nil) {
            self.title = title
            self.style = style
            self.customize = customize
        }
        
    }
    
    open class StartAlertDefaultViewController: UIViewController, StartAlertPresentable {
        
        public weak var alert: StartAlert!
        
        //public var title: String?
        public var message: String?
        
        public var inputs: [StartAlertViewInput] = []
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
                backgroundView.contentView.fillWithSubview(vibrancyView)
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
            
            if let title = title {
                let headerView = UIView()
                headerView.backgroundColor = UIColor.clear
                headerView.translatesAutoresizingMaskIntoConstraints = false
                headerView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
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
                titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(Int(UILayoutPriority.defaultHigh.rawValue)+1)), for: .vertical)
                headerView.addSubview(titleLabel)
                
                switch alert.style {
                case .top, .bottom, .center, .full:
                    () // Nothing
                case .navbar, .ticker:
                    let color1 = UINavigationBar.appearance().titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
                    let color2 = UINavigationBar.appearance().tintColor
                    titleLabel.textColor = color1 ?? color2 ?? UIColor.black
                }
                
                
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
                let contentView = UIView()
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
                messageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.RawValue(Int(UILayoutPriority.defaultLow.rawValue)-1)), for: .vertical)
                contentView.addSubview(messageLabel)
                
                switch alert.style {
                case .top, .bottom, .center, .full:
                    () // Nothing
                case .navbar, .ticker:
                    let color1 = UINavigationBar.appearance().titleTextAttributes?[NSAttributedStringKey.foregroundColor] as? UIColor
                    let color2 = UINavigationBar.appearance().tintColor
                    messageLabel.textColor = color1 ?? color2 ?? UIColor.black
                }
                
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
            
            
            
            
            
            
            
            
            
            
            if inputs.count > 0 {
                let inputsView = UIView()
                inputsView.backgroundColor = UIColor.clear
                inputsView.translatesAutoresizingMaskIntoConstraints = false
                inputsView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
                view.addSubview(inputsView)
                
                // Add constraints
                view.addConstraint(
                    NSLayoutConstraint(
                        item: inputsView, attribute: .top,
                        relatedBy: .equal,
                        toItem: topView, attribute: (topView == view ? .top : .bottom),
                        multiplier: 1.0, constant: 0
                    )
                )
                view.addConstraint(
                    NSLayoutConstraint(
                        item: inputsView, attribute: .leading,
                        relatedBy: .equal,
                        toItem: view, attribute: .leading,
                        multiplier: 1.0, constant: 0
                    )
                )
                view.addConstraint(
                    NSLayoutConstraint(
                        item: view, attribute: .trailing,
                        relatedBy: .equal,
                        toItem: inputsView, attribute: .trailing,
                        multiplier: 1.0, constant: 0
                    )
                )
                view.addConstraint(
                    NSLayoutConstraint(
                        item: inputsView, attribute: .height,
                        relatedBy: .greaterThanOrEqual,
                        toItem: nil, attribute: .notAnAttribute,
                        multiplier: 1.0, constant: 50
                    )
                )
                
                var beforeView: UIView = inputsView
                for input in inputs {
                    
                    let inputInput: UIControl = UITextField()
                    inputInput.translatesAutoresizingMaskIntoConstraints = false
                    inputsView.addSubview(inputInput)
                    input.view = inputInput
                    
                    // Add constraints
                    inputsView.addConstraint(
                        NSLayoutConstraint(
                            item: inputInput, attribute: .top,
                            relatedBy: .equal,
                            toItem: beforeView, attribute: (beforeView == inputsView ? .top : .bottom),
                            multiplier: 1.0, constant: (beforeView == inputsView ? 0 : 10)
                        )
                    )
                    inputsView.addConstraint(
                        NSLayoutConstraint(
                            item: inputsView, attribute: .trailing,
                            relatedBy: .equal,
                            toItem: inputInput, attribute: .trailing,
                            multiplier: 1.0, constant: 20
                        )
                    )
                    inputsView.addConstraint(
                        NSLayoutConstraint(
                            item: inputInput, attribute: .leading,
                            relatedBy: .equal,
                            toItem: inputsView, attribute: .leading,
                            multiplier: 1.0, constant: 20
                        )
                    )
                    
                    inputInput.addConstraint(
                        NSLayoutConstraint(
                            item: inputInput, attribute: .height,
                            relatedBy: .equal,
                            toItem: nil, attribute: .notAnAttribute,
                            multiplier: 1.0, constant: 50
                        )
                    )
                    
                    switch input.style {
                    case .textField:
                        let inputInput = inputInput as! UITextField
                        inputInput.placeholder = input.title
                        inputInput.font = UIFont.systemFont(ofSize: 16)
                        inputInput.textColor = UIColor.black
                        inputInput.textAlignment = .center
                        inputInput.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
                        inputInput.layer.cornerRadius = 4
                        inputInput.layer.masksToBounds = true
                    }
                    
                    input.customize?(inputInput)
                    
                    beforeView = inputInput
                }
                
                inputsView.addConstraint(
                    NSLayoutConstraint(
                        item: inputsView, attribute: .bottom,
                        relatedBy: .equal,
                        toItem: beforeView, attribute: .bottom,
                        multiplier: 1.0, constant: 20
                    )
                )
                
                topView = inputsView
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            if buttons.count > 0 {
                let buttonsView = UIView()
                buttonsView.backgroundColor = UIColor.clear
                buttonsView.translatesAutoresizingMaskIntoConstraints = false
                buttonsView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)
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
                
                var beforeView: UIView = buttonsView
                for button in buttons {
                    
                    let buttonButton = UIButton()
                    buttonButton.translatesAutoresizingMaskIntoConstraints = false
                    buttonsView.addSubview(buttonButton)
                    
                    
                    if buttons.count <= 2 {
                        
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
                                toItem: beforeView, attribute: (beforeView == buttonsView ? .leading : .trailing),
                                multiplier: 1.0, constant: (beforeView == buttonsView ? 0 : 1)
                            )
                        )
                        if beforeView != buttonsView {
                            buttonsView.addConstraint(
                                NSLayoutConstraint(
                                    item: buttonButton, attribute: .width,
                                    relatedBy: .equal,
                                    toItem: beforeView, attribute: .width,
                                    multiplier: 1.0, constant: 0
                                )
                            )
                        }
                        
                    } else {
                        
                        // Add constraints
                        buttonsView.addConstraint(
                            NSLayoutConstraint(
                                item: buttonButton, attribute: .top,
                                relatedBy: .equal,
                                toItem: beforeView, attribute: (beforeView == buttonsView ? .top : .bottom),
                                multiplier: 1.0, constant: (beforeView == buttonsView ? 0 : 1)
                            )
                        )
                        buttonsView.addConstraint(
                            NSLayoutConstraint(
                                item: buttonsView, attribute: .trailing,
                                relatedBy: .equal,
                                toItem: buttonButton, attribute: .trailing,
                                multiplier: 1.0, constant: 0
                            )
                        )
                        buttonsView.addConstraint(
                            NSLayoutConstraint(
                                item: buttonButton, attribute: .leading,
                                relatedBy: .equal,
                                toItem: buttonsView, attribute: .leading,
                                multiplier: 1.0, constant: 0
                            )
                        )
                        if beforeView != buttonsView {
                            buttonsView.addConstraint(
                                NSLayoutConstraint(
                                    item: buttonButton, attribute: .height,
                                    relatedBy: .equal,
                                    toItem: beforeView, attribute: .height,
                                    multiplier: 1.0, constant: 0
                                )
                            )
                        } else {
                            buttonButton.addConstraint(
                                NSLayoutConstraint(
                                    item: buttonButton, attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil, attribute: .notAnAttribute,
                                    multiplier: 1.0, constant: 50
                                )
                            )
                        }
                        
                    }
                    
                    buttonButton.setTitle(button.title, for: .normal)
                    buttonButton.setAction({ (sender) in
                        guard let alert = self.alert else { return }
                        button.action(alert, sender as AnyObject)
                    })
                    buttonButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    buttonButton.setTitleColor(UIColor.black, for: .normal)
                    buttonButton.backgroundColor = button.style.backgroundColor
                    
                    beforeView = buttonButton
                }
                
                if buttons.count <= 2 {
                    
                    buttonsView.addConstraint(
                        NSLayoutConstraint(
                            item: buttonsView, attribute: .trailing,
                            relatedBy: .equal,
                            toItem: beforeView, attribute: .trailing,
                            multiplier: 1.0, constant: 0
                        )
                    )
                    
                } else {
                    
                    buttonsView.addConstraint(
                        NSLayoutConstraint(
                            item: buttonsView, attribute: .bottom,
                            relatedBy: .equal,
                            toItem: beforeView, attribute: .bottom,
                            multiplier: 1.0, constant: 0
                        )
                    )
                    
                }
                
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
    
    
    fileprivate extension UIButton {
        
        fileprivate func setAction(_ action: @escaping ((_ sender: Any) -> Void)) {
            setAction(controlEvents: .touchUpInside, action: action)
        }
        
    }
    
    private var _dhsv: UInt8 = 0
    private final class ClosureWrapper {
        fileprivate var action: (_ sender: Any) -> Void
        init(action: @escaping (_ sender: Any) -> Void) {
            self.action = action
        }
    }
    
    fileprivate extension UIControl {
        
        fileprivate func setAction(controlEvents: UIControlEvents, action: ((_ sender: Any) -> Void)?) {
            if let action = action {
                self.removeTarget(self, action: nil, for: controlEvents)
                self.addTarget(self, action: #selector(UIControl.performAction), for: controlEvents)
                self.closuresWrapper = ClosureWrapper(action: action)
            } else {
                self.removeTarget(self, action: nil, for: controlEvents)
                self.closuresWrapper = nil
            }
        }
        
        @objc fileprivate func performAction() {
            self.closuresWrapper?.action(self)
        }
        
        fileprivate var closuresWrapper: ClosureWrapper? {
            get { return objc_getAssociatedObject(self, &_dhsv) as? ClosureWrapper }
            set { objc_setAssociatedObject(self, &_dhsv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        }
        
    }
    
#endif
