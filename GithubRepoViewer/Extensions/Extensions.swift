//
//  Extensions.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import UserNotifications


extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    func pushRequestNotificationStatus() -> Bool {
        guard let settings = UIApplication.shared.currentUserNotificationSettings
            else {
                return false
        }
        
        if settings.types.rawValue > 0 {//&& UIApplication.shared.isRegisteredForRemoteNotifications {
            return true
        }
        
        return false
    }
}

// MARK: - UIViewController

extension UIViewController: RoutableView {
    
    private class func instantiateControllerInStoryboard<T: UIViewController>(_ storyboard: UIStoryboard, identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard, identifier: String) -> Self {
        return instantiateControllerInStoryboard(storyboard, identifier: identifier)
    }
    
    class func controllerInStoryboard(_ storyboard: UIStoryboard) -> Self {
        return controllerInStoryboard(storyboard, identifier: nameOfClass)
    }
    
    class func controllerFromStoryboard(_ storyboard: Storyboards) -> Self {
        return controllerInStoryboard(UIStoryboard(name: storyboard.rawValue, bundle: nil), identifier: nameOfClass)
    }
    
    // MARK: - handlers
    
    func showMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func waitForComplete(completion: (() -> ())? = nil, callback: @escaping (() -> ())) {
        debugPrint("begin throbber " + self.debugDescription)
        let alert = UIAlertWiredController(title: nil, message: "", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: alert.view.bounds)
        loadingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.startAnimating()
        
        alert.callback = callback
        alert.view.addSubview(loadingIndicator)
        
        alert.view.alpha = 0.0
        if let firstSubview = alert.view?.subviews.first {
            firstSubview.alpha = 0.0
        }
        
        present(alert, animated: true, completion: completion)
        
        Timer.scheduledTimer(timeInterval: AppConstants.WaitingTimeout,
                             target: self,
                             selector: #selector(abortWiredAlert),
                             userInfo: alert,
                             repeats: false)
    }
    
    func dismissWiredController()  {
        if let vc = self as? UIAlertWiredController {
            debugPrint("end throbber " + self.debugDescription)
            vc.dismissWithCustomCompletion()
        } else {
            debugPrint("not throbber " + self.debugDescription)
            let presented = self.presentedViewController
            presented?.dismissWiredController()
        }
        
    }
    
    @objc func abortWiredAlert(_ timer: Timer) {
        let view = timer.userInfo as? UIAlertWiredController
        view?.dismissWithCustomCompletion()
        timer.invalidate()
    }
    
    func alertDialog(title: String, message: String, okAction: UIAlertAction, cancelAction: UIAlertAction? = UIAlertAction(title: "NO".localized(),
                                                                                                                           style:.cancel)) {
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        
        if let ca = cancelAction {
            alertVC.addAction(ca)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: false, completion: {
        })
    }
    
    //MARK: - Routable view protocol
    
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToTabBarController(vc: UITabBarController) {
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
    }
    
    func switchNavigationController(vc: UINavigationController) {
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
    }
    
    func pop() -> UIViewController? {
        return navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() -> [UIViewController]? {
        return navigationController?.popToRootViewController(animated: true)
    }
    
    func present(customView: UIViewController) {
        customView.modalPresentationStyle = .custom
        present(customView, animated: true, completion: nil)
    }
    
    @objc func didBecomeActive() {
        //DO NOT TOUCH STUB
    }
    
    @objc func didEnterBackground() {
        //DO NOT TOUCH STUB
    }
    
    @objc func onError(reason: String) {
        debugPrint(reason)
    }
}

// MARK: - NSObject

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
