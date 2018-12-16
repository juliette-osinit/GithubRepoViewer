//
//  AppConstants.swift
//  GithubRepoViewer
//
//  Created by Julia Mineeva on 16/12/2018.
//  Copyright © 2018 Julia Mineeva. All rights reserved.
//

import Foundation
import UIKit


struct AppConstants {

    // MARK: - Alert
    
    static let WaitingTimeout: TimeInterval = 15.0

    // MARK: - API
    
    static let Cookies: String = "Cookies"
    static let LogKey: String = "LogKey"
    static let CookiesSupport: String = "Cookies-support"
    static let CookieHeaderKey: String = "Set-Cookie"
    static let UserAgent: String = "PAYEER eWallet Mobile "
    static let ResetDeviceToken: String = "ResetDeviceToken"
    
    static let PasswordPrefix = "PASSWORD:"
    static let CryptoAppVersKey: String = "CryptoAppVersKey"
    static let CryptoAppVers: Int = 2
    
    // TODO: - need to remove it from here
    
    static var EndpointURL: String {
        return stringFromPlist(plist: "AppConfig", key: "API_URL")
    }
    
    static func stringFromPlist(plist: String, key:String) -> String {
        if let path = Bundle.main.path(forResource:plist, ofType: "plist") {
            let plistXML = FileManager.default.contents(atPath: path)!
            var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml
            var plistData: [String: AnyObject] = [:]
            do {//convert the data to a dictionary and handle errors.
                plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
                return plistData[key] as? String ?? ""
            } catch {
                print("Error reading plist: \(error), format: \(propertyListForamt)")
            }
        }
        return ""
    }
    
    // MARK: - Tokens helper
    
    static func isNeededToResendToken() -> Bool {
        return (UserDefaults.standard.value(forKey:AppConstants.ResetDeviceToken) as? Bool) ?? false
    }
    
    static func resendToken(_ resend: Bool) {
        UserDefaults.standard.setValue(resend, forKey: AppConstants.ResetDeviceToken)
    }
    
}
