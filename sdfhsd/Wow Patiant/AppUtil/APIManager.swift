//
//  APIManager.swift
//  Wow Patient
//
//  Created by Amir on 29/04/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
    
    // MARK: - Get Request
    class func getAPIRequest(_ urlStr : String, parameter : Parameters?, success:@escaping(NSDictionary) -> Void, failure:@escaping (Error) -> Void)
    {
        let defaultt  = UserDefaults.standard
        let userID = defaultt.integer(forKey: "userid")
        let tokenstr = defaultt.value(forKey: "token") as! String
        let header : HTTPHeaders = ["auth-token" : tokenstr, "auth-userID" : "\(userID)"]

        Alamofire.request(urlStr, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value
                    != nil
                {
                    let resJson = (response.result.value!)
                    success(resJson as! NSDictionary)
                }
                break
            case .failure(_):
                let error : Error =  response.result.error!
                failure(error)
                break
            } // switch End
        }
    } // end Method
    
    // MARK: -  Post Api Request
    class func postAPIRequest(_ url : String, parameter : Parameters, success:@escaping(NSDictionary) -> Void, failure:@escaping(Error) -> Void)
    {
        let defaultt  = UserDefaults.standard
        let userID = defaultt.integer(forKey: "userid")
        let tokenstr = defaultt.value(forKey: "token") as! String
        let header : HTTPHeaders = ["auth-token" : tokenstr, "auth-userID" : "\(userID)"]
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            (response : DataResponse<Any>) in
            
            switch(response.result)
            {
            case .success(_):
                let jsonResult = response.result.value
                success(jsonResult as! NSDictionary)
                break
            case .failure(_):
                let error : Error = response.result.error!
                failure(error)
                break
            
            } // switch End
        }
    } // end method
    
    // MARK: - Delete Api Request
    class func deleteAPIRequest(_ url : String, parameter : Parameters?, success:@escaping(NSDictionary) -> Void, failure:@escaping(Error) -> Void)
    {
        let defaultt  = UserDefaults.standard
        let userID = defaultt.integer(forKey: "userid")
        let tokenstr = defaultt.value(forKey: "token") as! String
        let header : HTTPHeaders = ["auth-token" : tokenstr, "auth-userID" : "\(userID)"]
        Alamofire.request(url, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON{
            (response : DataResponse<Any>) in
            switch(response.result)
            {
            case .success(_):
                let jsonResult = response.result.value
                success(jsonResult as! NSDictionary)
                break
            case .failure(_):
                let error : Error = response.result.error!
                failure(error)
                break
                
            } // switch End
        }
    } // end method
} // end class
