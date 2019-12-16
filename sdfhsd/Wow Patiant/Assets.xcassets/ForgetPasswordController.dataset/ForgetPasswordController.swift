//
//  ForgetPasswordController.swift
//  Wow Patient
//
//  Created by Amir on 31/03/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

class ForgetPasswordController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate {

    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var scrollView : UIScrollView!
    
    
    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: self.emailTextField.placeholder!, attributes:[NSForegroundColorAttributeName : UIColor.black])
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.scrollView.delegate = self
        self.emailTextField.delegate = self
        self.emailTextField.keyboardType = UIKeyboardType.asciiCapable
        self.emailTextField.returnKeyType = .done
    
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordController.showKeyBoard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordController.hidingKeyBoard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func sendLinkForgetPassword(_ sender: Any)
    {
    
        let forgetPasswordUrl = UrlUtil.getForgetPasswordUrl()
        guard (self.emailTextField.text?.characters.count)! > 1 else
        {
        self.showAlertView(titlee: "Enter Email", messagee: "")
            return
        }
        if self.checkEmaillIsValid() == false
        {
            self.showAlertView(titlee: "Email is incorrect", messagee: "'")
            return
        }
        
        let emailStr = self.emailTextField.text!
        Alamofire.request(forgetPasswordUrl, method: .post, parameters: ["email" : emailStr], encoding: JSONEncoding.default, headers: nil).responseJSON{(response:DataResponse<Any>) in
        
        switch(response.result)
        {
        case .success(_):
            
            let mainDict = response.result.value as! NSDictionary
            let statusDict = mainDict.value(forKey: "status") as! NSDictionary
            let messageDict = statusDict.value(forKey: "message") as! NSDictionary
            
            let successCode =  messageDict.value(forKey: "code") as! String
            
            if successCode.contains(UrlUtil.getSuccessCode())
            {
            
                let alertController = UIAlertController(title: "Password Send Your  Email", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
                    (action : UIAlertAction) -> Void in
                    let goToLoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(goToLoginController, animated: true)
                    
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            else
            {
                 let errorMesageStr = messageDict.value(forKey: "details")
                
                let alertController = UIAlertController(title: errorMesageStr as? String , message: "", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
                    (action : UIAlertAction) -> Void in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            break
        case .failure(_):
            self.showAlertView(titlee: "No respsone revecived", messagee: "")
            break
        }// end switch
            
        } // end webservice
        
    } // end func
    
    
    // MARK: - KeyBoard Delegate Method
    func showKeyBoard(notification :  NSNotification)
    {
        let keyBoardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
    }
    func hidingKeyBoard(notification :  NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }, completion: nil)
    }

    
    // MARK: - TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    /* email validation */
    func checkEmaillIsValid()-> Bool
    {
        // let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let emailcharater =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: " SELF MATCHES %@", emailcharater)
        let isValidEmail = emailPredicate.evaluate(with: self.emailTextField.text)
        return isValidEmail
    }
    
    // MARK: - Show Alert Controller
    func showAlertView(titlee : NSString, messagee : NSString)
    {
        let alertController = UIAlertController(title: titlee as String, message: messagee as String, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            // male is Selected
        }))
        present(alertController, animated: true, completion: nil)
    } // end function

    
    
    
    

}
