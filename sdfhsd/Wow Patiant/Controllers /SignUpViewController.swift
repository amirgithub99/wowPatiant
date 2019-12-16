//
//  SignUpViewController.swift
//  Wow Patient
//
//  Created by Amir on 30/03/2018.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController , UITextFieldDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate{

    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var contentVieww : UIView!
    @IBOutlet weak var dateOfBirthView : UIView!
    @IBOutlet weak var genderView : UIView!
    @IBOutlet weak var largeDatePickerView: UIView!
     var largeGenderVieww = UIView()
    
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var middelNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var socialNoTxtField: UITextField!
    @IBOutlet weak var dateBirthTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var datePickerr : UIDatePicker!
    var isDateOfBirthSelected = Bool()
    var isGenerSelected = Bool()
    var dateOfBirth = String()
    var genderStr = String()
    
    
    
    @IBOutlet weak var dateSubView: UIView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.scrollView.delegate = self
        
        self.firstNameTxtField.delegate = self
        self.middelNameTxtField.delegate = self
        self.lastNameTxtField.delegate = self
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.confirmPasswordTxtField.delegate = self
        self.socialNoTxtField.delegate = self
        
        self.firstNameTxtField.keyboardType = UIKeyboardType.alphabet
        self.middelNameTxtField.keyboardType = UIKeyboardType.asciiCapable
        self.lastNameTxtField.keyboardType = UIKeyboardType.asciiCapable
        self.emailTxtField.keyboardType = UIKeyboardType.asciiCapable
        self.passwordTxtField.keyboardType = UIKeyboardType.asciiCapable
        self.confirmPasswordTxtField.keyboardType = UIKeyboardType.asciiCapable
        self.socialNoTxtField.keyboardType = UIKeyboardType.asciiCapableNumberPad
    
        self.genderTxtField.delegate = self
        self.dateBirthTxtField.delegate = self
        
        self.firstNameTxtField.returnKeyType = UIReturnKeyType.done
        self.middelNameTxtField.returnKeyType = UIReturnKeyType.done
        self.lastNameTxtField.returnKeyType = UIReturnKeyType.done
        self.emailTxtField.returnKeyType = UIReturnKeyType.done
        self.confirmPasswordTxtField.returnKeyType = UIReturnKeyType.done
        self.socialNoTxtField.returnKeyType = UIReturnKeyType.done
        
        self.datePickerr.datePickerMode = .date
        let minimumDateStr = "Jan 01, 1900"
        let formatterr = DateFormatter()
        formatterr.dateFormat = "MMM dd, yyyy";
        let minimumDate = formatterr.date(from: minimumDateStr)
        self.datePickerr.minimumDate = minimumDate
        self.datePickerr.maximumDate = Date()
     
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.hidingKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        self.addingGestureRecognizerInBirthViewGenderView()
    }
    
    // MARK: - Adding Gesture in BirthView & GenderVIew
    func addingGestureRecognizerInBirthViewGenderView()
    {
        let birthViewGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.showdatePicker(sender:)))
        birthViewGesture.delegate = self
        birthViewGesture.numberOfTapsRequired = 1
        self.dateBirthTxtField.addGestureRecognizer(birthViewGesture)
        
        let genderViewGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.showGenderView(sender:)))
        genderViewGesture.delegate = self
        genderViewGesture.numberOfTapsRequired = 1
        self.genderTxtField.addGestureRecognizer(genderViewGesture)
        
//        let dateViewGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.cancelDatePickerView(sender:)))
//        dateViewGesture.delegate = self
//        dateViewGesture.numberOfTapsRequired = 1
//        self.largeDatePickerView.addGestureRecognizer(dateViewGesture)
    
    }
    
//    @objc func cancelDatePickerView(sender: UITapGestureRecognizer)
//    {
//        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
//            self.largeDatePickerView.alpha = 0
//        }, completion: {
//            (finished) -> Void in
//            self.largeDatePickerView.isHidden = true
//        })
//    }
//
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: self.dateSubView))!
        {
            print("ssssss")
            return false
        }
        return true
    }
    
    // MARK:- show Date PickerView
     @objc func showdatePicker(sender :  UITapGestureRecognizer)
    {
        self.contentVieww.endEditing(true)
        self.largeDatePickerView.isHidden = false
        self.largeDatePickerView.alpha = 1
        self.view.bringSubview(toFront: self.largeDatePickerView)
         self.largeDatePickerView.backgroundColor = UIColor().getCustomBlurColor()
        self.largeDatePickerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: [], animations: {
            self.largeDatePickerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
    }
    @IBAction func cancelDatePicker(_ sender: Any)
    {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.largeDatePickerView.alpha = 0
        }, completion: {
            (finished) -> Void in
            self.largeDatePickerView.isHidden = true
        })
    }
    @IBAction func doneDatePicker(_ sender: Any)
    {
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.largeDatePickerView.alpha = 0
        }, completion: {
            (finished) -> Void in
            self.largeDatePickerView.isHidden = true
        })
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
         let dateStr = formatter.string(from: self.datePickerr.date)
        self.dateBirthTxtField
            .text =  dateStr
        self.dateOfBirth = dateStr
        self.isDateOfBirthSelected = true
    }
    // MARK: - Show Gender View
    @objc func showGenderView(sender : UITapGestureRecognizer)
    {
        self.contentVieww.endEditing(true)
        let alertController = UIAlertController(title: "Select Gender ", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title : "Male", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            self.isGenerSelected = true
            self.genderStr = "Male"
            self.genderTxtField.text = self.genderStr
            
            // male is Selected
        }))
        alertController.addAction(UIAlertAction(title : "Female", style:.default, handler:{
            (action : UIAlertAction) -> Void in
            // female is selected
            self.isGenerSelected = true
             self.genderStr = "Female"
            self.genderTxtField.text = self.genderStr
        }))
        alertController.addAction(UIAlertAction(title : "Other", style:.default, handler:
            {
                (action:  UIAlertAction) -> Void in
                //other is selected
                self.isGenerSelected = true
                self.genderStr = "Other"
                self.genderTxtField.text = self.genderStr
                
        }))
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - KeyBoard Delegate Method
     @objc func showKeyBoard(notification :  NSNotification)
    {
        var keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
       keyboardHeight = keyboardHeight + 30
        
        print("TTTTTTT", keyboardHeight)
        UIView.animate(withDuration: 0.5, animations: {
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
        }, completion: nil)
    }
    @objc func hidingKeyBoard(notification :  NSNotification)
    {
        UIView.animate(withDuration: 0.5, animations: { 
             self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }, completion: nil)
    }
    // MARK: - Sign UP
    @IBAction func signUpForRegistration(_ sender: Any)
    {
        guard (self.firstNameTxtField.text?.count)! > 1 else
        {
            self.showAlertView(title: "Enter First Name", message: "")
            return
        }
//        guard (self.middelNameTxtField.text?.count)! > 1 else
//        {
//            self.showAlertView(title: "Enter Middle Name", message: "")
//            return
//        }
        guard (self.lastNameTxtField.text?.count)! > 1 else
        {
            self.showAlertView(title: "Enter Last Name", message: "")
            return
        }
        guard self.isDateOfBirthSelected == true else
        {
            self.showAlertView(title: "Select Date of Birth", message: "")
            return
        }
        guard self.isGenerSelected == true else
        {
            self.showAlertView(title: "Select Gender ", message: "")
            return
        }
        guard (self.socialNoTxtField.text?.count)! > 1 else
        {
            self.showAlertView(title: "Enter Social No", message: "")
            return
        }
        guard (self.emailTxtField.text?.count)! > 1 else
        {
            self.showAlertView(title: "Enter Email Id", message: "")
            return
        }
        guard self.checkEmaillIsValid() == true else {
            self.showAlertView(title: "Email is Incorrect", message: "")
            return
        }
        guard (self.passwordTxtField.text?.count)! > 1 else {
            self.showAlertView(title: "Enter  Password", message: "")
            return
        }
        guard (self.passwordTxtField.text?.count)! > 7 else {
            self.showAlertView(title: "Enter 8 Digit Password", message: "")
            return
        }
        guard self.passwordTxtField.text == self.confirmPasswordTxtField.text else
        {
            self.showAlertView(title: "Password and confirm Passsword Mismatch ", message: "")
          return
        }
        
        let firstNameStr = self.firstNameTxtField.text
        let middleNameStr = self.middelNameTxtField.text
        let lastNameStr = self.lastNameTxtField.text
        let birthStr = self.dateOfBirth
        let genderStrr = self.genderStr
        let scicalStr = self.socialNoTxtField.text
        let emailStr = self.emailTxtField.text
        let paswordStr = self.passwordTxtField.text
        
        
        let parameterr = ["firstName" : firstNameStr, "middleName" : middleNameStr, "lastName" : lastNameStr, "dob" : birthStr, "gender" : genderStrr, "ssn" : scicalStr, "email" : emailStr, "password" : paswordStr]
        let signUpurl = UrlUtil.getSignUpUrl()
        let indicatorActivity = MBProgressHUD.showAdded(to: self.view, animated: true);
        indicatorActivity.label.text = "Loading";
        //indicatorActivity.detailsLabel.text = "";
        //indicatorActivity.isUserInteractionEnabled = false;
        guard AppUtil.isInternetConnected() == true else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showAlertView(title: "No internet Connection", message: "")
            return
        }
        
        APIManager.postAPIRequest(signUpurl, parameter:parameterr, success: { (JSONResponse) -> Void in
            
            let mainDictionary =  JSONResponse
            let statusDict = mainDictionary.value(forKey: "status") as! NSDictionary
            let statusObj : Status = Status.init(statusDict: statusDict as! Dictionary<String, Any>)
            let messageCode = statusObj.message?.code
            if (messageCode?.contains("S001"))!
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                let alertController = UIAlertController(title: "Successful Registration" , message: "", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title : "Ok", style:.default, handler:{
                                (action : UIAlertAction) -> Void in
                
                let goToLoginContrler = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(goToLoginContrler, animated: true)
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
        
    } // end method
    
    // MARK: - goTo SignInController
    @IBAction func goToSignInController(_ sender : Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Text Field Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == self.dateBirthTxtField || textField == self.genderTxtField
        {
            textField.resignFirstResponder()
            if textField == self.dateBirthTxtField
            {
            }
            else if textField == self.genderTxtField
            {
            }
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.socialNoTxtField
        {
            let chareacter = NSCharacterSet(charactersIn: "0123456789").inverted
            let isValidChareacter = string.rangeOfCharacter(from: chareacter, options: [], range: string.startIndex..<string.endIndex) == nil
            if !isValidChareacter
            {
                return false
            }
            else
            {
              return true
            }
        }
        return true
    } // end function
    /* email validation */
    func checkEmaillIsValid()-> Bool
    {
        // let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let emailcharater =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPredicate = NSPredicate(format: " SELF MATCHES %@", emailcharater)
        let isValidEmail = emailPredicate.evaluate(with: self.emailTxtField.text)
        return isValidEmail
    }
}
