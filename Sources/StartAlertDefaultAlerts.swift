//
//  StartAlertDefaultAlerts.swift
//  StartAppsKitLearn
//
//  Created by Gabriel Lanata on 18/9/16.
//  Copyright © 2016 Universidad de Lima. All rights reserved.
//

import Foundation

#if os(iOS)

public extension StartAlert {
    
    public class func full(title: String?, message: String?, dismissTitle: String = "OK") -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.title = title
        innerAlert.message = message
        innerAlert.buttons.append(StartAlertViewButton(title: dismissTitle, action: .cancel))
        let alert = StartAlert(style: .full, overlay: .blur, animation: .zoom)
        alert.rootViewController = innerAlert
        return alert
    }
    
    public class func top(title: String?, message: String?, dismissTitle: String = "OK") -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.title = title
        innerAlert.message = message
        innerAlert.buttons.append(StartAlertViewButton(title: dismissTitle, action: .cancel))
        let alert = StartAlert(style: .top, overlay: .blur, animation: .top)
        alert.rootViewController = innerAlert
        return alert
    }
    
    public class func bottom(title: String?, message: String?, dismissTitle: String = "OK") -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.title = title
        innerAlert.message = message
        innerAlert.buttons.append(StartAlertViewButton(title: dismissTitle, action: .cancel))
        let alert = StartAlert(style: .bottom, overlay: .blur, animation: .bottom)
        alert.rootViewController = innerAlert
        return alert
    }
    
    public class func center(title: String?, message: String?, dismissTitle: String = "OK") -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.title = title
        innerAlert.message = message
        innerAlert.buttons.append(StartAlertViewButton(title: dismissTitle, action: .cancel))
        let alert = StartAlert(style: .center, overlay: .blur, animation: .zoom)
        alert.rootViewController = innerAlert
        return alert
    }
    
    public class func navbar(message: String?) -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.message = message
        let alert = StartAlert(style: .navbar, overlay: .none, animation: .top)
        alert.rootViewController = innerAlert
        return alert
    }
    
    public class func ticker(message: String?) -> StartAlert {
        let innerAlert = StartAlertDefaultViewController()
        innerAlert.message = message
        let alert = StartAlert(style: .ticker, overlay: .none, animation: .top)
        alert.rootViewController = innerAlert
        return alert
    }
    
}

#endif
