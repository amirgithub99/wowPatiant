//  LoginViewController.swift
//  Wow Patient
//  Created by Amir on 30/03/2018.
//  Copyright © 2018 Amir. All rights reserved.

import UIKit
import Alamofire

class LoginViewController: UIViewController , UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate{

    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewidthContraint: NSLayoutConstraint!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var rememberBtn: UIButton!

    var screenHight = Int()
    var screenWidth = Int()
    var activityIndicatorr : UIActivityIndicatorView = UIActivityIndicatorView()
    var isRememberPassword = Bool()
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
       screenHight  = Int(self.view.frame.size.height);
        screenWidth  = Int(self.view.frame.size.width);
        self.isRememberPassword = false
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
        {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.nameTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.nameTxtField.returnKeyType = UIReturnKeyType.next
        self.passwordTxtField.returnKeyType = UIReturnKeyType.done
        
        /* dismiss KeyBoard By TouchingOutside txtField*/
        let gesturRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyBoardOnTouchingOutsideTextField(_:)))
        gesturRecognizer.delegate = self
        gesturRecognizer.cancelsTouchesInView = false
        self.contentView.addGestureRecognizer(gesturRecognizer)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.showingKeyBoard(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.hidingKeyBoard(notifaction:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
       // MBProgressHUD.hide(for: self.contentView, animated: true)
    }
    // MARK:- keyBoard Delegate Method
    @objc func showingKeyBoard(notification : NSNotification)
    {
        var keyBoardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        keyBoardHeight = keyBoardHeight + 30
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyBoardHeight, 0.0)
        }, completion: nil)
    }
    @objc func hidingKeyBoard(notifaction : NSNotification)
    {
       UIView.animate(withDuration: 0.5, animations: {
        
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0)

          //self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
       }, completion: nil)
    }
    @objc func dismissKeyBoardOnTouchingOutsideTextField(_ sender : UIGestureRecognizer)
    {
      self.view.endEditing(true)
    }
    // MARK:- Create Sign Up
    @IBAction func createSignUpForResgistration(_ sender: Any)
    {
        let goToSignUpController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(goToSignUpController, animated: true)
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    {
        return false
        
    }
    //MARK:- Show Forget Controller
    @IBAction func showFogetPasswordViewController(_ sender: Any)
    {

        let goToForgetController = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordController") as! ForgetPasswordController
        self.navigationController?.pushViewController(goToForgetController, animated: true)
    }

    @IBAction func checkRememberPassword(_ sender: Any)
    {
        if self.isRememberPassword == false
        {
             self.rememberBtn.setImage(UIImage(named: "checkBOxImg"), for: .normal)
            self.isRememberPassword = true
        }
        else
        {
            self.rememberBtn.setImage(UIImage(named: "unCheckBOxImg"), for: .normal)
           self.isRememberPassword = false
        }
    }
    // MARK: - Sign In
    @IBAction func userSigning(_ sender: Any)
    {

       
//        self.activityIndicatorr.center = self.view.center
//        self.activityIndicatorr.hidesWhenStopped = true
//        self.activityIndicatorr.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        self.contentView.addSubview(self.activityIndicatorr)
//        self.activityIndicatorr.startAnimating()
//        UIApplication.shared.beginIgnoringInteractionEvents()
   
        guard (self.nameTxtField.text?.count)! > 1 else {
            // enter Email
            self.showAlertView(title: "Enter Email Id", message: "")
            return
        }
   guard (self.passwordTxtField.text?.count)! > 1 else {
            // enter Password
            self.showAlertView(title: "Enter Password", message: "")
            return
        }
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            //MBProgressHUD().bezelView.backgroundColor = UIColor.red
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }

        
        let emailStr =  self.nameTxtField.text!
        let passWordStr = self.passwordTxtField.text!
    
         let urlLogin = UrlUtil.getLoginUrl()
        let parameters: Parameters = [
            "username": emailStr,
            "password": passWordStr
        ]
        Alamofire.request(urlLogin, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
            if response.result.value
                    != nil
            {
                     MBProgressHUD.hide(for: self.view, animated: true)
                    let defaultt  = UserDefaults.standard
                    let mainDictionary = response.result.value as! NSDictionary
                    let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
                    let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
                
                    let messageCode = statusObj.message?.code
                    if (messageCode?.contains("S001"))!
                    {
                        let loginDict = mainDictionary.value(forKey: "login") as! NSDictionary
                       // let user : User = User.init(dict: loginDict as! Dictionary)
                        let tokinStr = loginDict.value(forKey: "token") as! String
                        let useridInt = loginDict.value(forKey: "userID") as! Int
                        let profossionInt =  loginDict.value(forKey: "userProfessionId") as! Int
                        defaultt.set(tokinStr, forKey: "token")
                        defaultt.set(useridInt, forKey: "userid")
                        defaultt.set(profossionInt, forKey: "userProfessionId")
                        let goToSignUpController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(goToSignUpController, animated: true);
                    }
                    else
                    {
                        let errorMessageStr = statusObj.message?.details
                        self.showAlertView(title: errorMessageStr!, message: "")
                        return
                    }
                }
                break
            case .failure(_):
                 MBProgressHUD.hide(for: self.view, animated: true)
                 self.showAlertView(title: "No response received", message: "")

                break
              } // switch end
        }
    } // end method

    func checkIsValidEmail() -> Bool
    {
        // let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let emailcharater =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: " SELF MATCHES %@", emailcharater)
        let isValidEmail = emailPredicate.evaluate(with: self.nameTxtField.text)
        return isValidEmail
    }
    
    // MARK: - Text Field Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField.returnKeyType == UIReturnKeyType.next
        {
            self.nameTxtField.resignFirstResponder()
            self.passwordTxtField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
      return true
    }
} //end Class

extension UIViewController {
    
    func showAlertView(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension UIColor {
    
    func getCustomBlurColor() -> UIColor
    {
        return UIColor.black.withAlphaComponent(0.3)
    }
}

