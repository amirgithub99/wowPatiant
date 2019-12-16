//
//  AppUtil.swift
//  Wow Patient
//
//  Created by Amir on 04/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit

import Alamofire

class AppUtil: NSObject {

    class func isInternetConnected() -> Bool
    {
      return NetworkReachabilityManager()!.isReachable
    }
    // MARK: - GEt HTTPHeaders
//    class func getHTTPHeaders() -> HTTPHeaders
//    {
//        let defaultt  = UserDefaults.standard
//        let userID = defaultt.integer(forKey: "userid")
//        let tokenstr = defaultt.value(forKey: "token") as! String
//        let headerr : HTTPHeaders = ["auth-token" : tokenstr, "auth-userID" :   "\(userID)"]
//
//        return headerr
//    }
    
    
    
}
