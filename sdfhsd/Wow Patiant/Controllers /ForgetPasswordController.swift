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
    
    @IBOutlet weak var emailTxtView: TextViewFont!
    
    // MARK:- View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: self.emailTextField.placeholder!, attributes:[NSAttributedStringKey.foregroundColor : UIColor.black])
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.scrollView.delegate = self
        self.emailTextField.delegate = self
        self.emailTextField.keyboardType = UIKeyboardType.asciiCapable
        self.emailTextField.returnKeyType = .done
        self.emailTxtView.isUserInteractionEnabled = false
        self.emailTxtView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordController.showKeyBoard(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ForgetPasswordController.hidingKeyBoard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    @IBAction func goBackToLoginViewController(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sendLinkForgetPassword(_ sender: Any)
    {
    
        guard (self.emailTextField.text?.characters.count)! > 1 else
        {
            
          self.showAlertView(title: "Enter Email", message: "")
            return
        }
        if self.checkEmaillIsValid() == false
        {
            self.showAlertView(title: "Email is incorrect", message: "'")
            return
        }
        
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        let forgetPasswordUrl = UrlUtil.getForgetPasswordUrl()
        let emailStr = self.emailTextField.text!
        APIManager.postAPIRequest(forgetPasswordUrl, parameter: ["email" : emailStr], success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                
                 MBProgressHUD.hide(for: self.view, animated: true)
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
                MBProgressHUD.hide(for: self.view, animated: true)
                let errorMessageStr = statusObj.message?.details
                self.showAlertView(title: errorMessageStr!, message: "")
            }

        }) { (error) -> Void in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No Response Received", message: "")
          }
    } // end func

    // MARK: - KeyBoard Delegate Method
    @objc func showKeyBoard(notification :  NSNotification)
    {
        var keyBoardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyBoardHeight = keyBoardHeight + 30
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
    }
    @objc func hidingKeyBoard(notification :  NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations: {
             self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
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
} // end class
