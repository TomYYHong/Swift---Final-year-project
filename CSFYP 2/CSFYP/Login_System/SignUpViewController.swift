//
//  SignUpViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 10/1/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var Password2: UITextField!
    @IBOutlet weak var Displayname: UITextField!
    @IBOutlet weak var confirmbutton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var BackToLoginButton: UIButton!
    var Islogged_in = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        BackButton.isHidden = true
        BackToLoginButton.isHidden = true
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                   
                     let uid = user.uid
                     let email = user.email
                    print("Logged in with:  ")
                   print("Email:  \(email ?? "error@gmail.com")************************")
                   print("Uid:  \(uid)*****************************")
                   }
        Islogged_in = true
          self.BackButton.isHidden = false
        }else {print("No logged in!!!")
             Islogged_in = false
            self.BackToLoginButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func Signup(_ sender: Any) {
      
       print(password1.text?.elementsEqual(Password2.text ?? "") ?? false)
        print(password1.text)
        print(Password2.text)
        
        if email.text == ""
        {
            let alertController = UIAlertController(title: "有嘢錯咗", message: "請輸入你嘅電郵地址！", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        }else if password1.text?.elementsEqual(Password2.text ?? "") ?? false == false
        {
            let alertController = UIAlertController(title: "有嘢錯咗", message: "請確保你輸入嘅密碼同確認密碼相同！", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else if Displayname.text == "" {
            let alertController = UIAlertController(title: "有嘢錯咗", message: "請輸入你嘅用戶名稱！", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: email.text!, password: password1.text!) { (user, error) in
                
                if error == nil {
                    print("係已經成功註冊喇！")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let alertController = UIAlertController(title: "搞掂", message: "你已經成功註冊喇！", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                   
                    //Testing part of upload display name!!!1
                    let name = self.Displayname.text
                           
                           let user = Auth.auth().currentUser
                           if let user = user {
                           
                             let uid = user.uid
                             let email = user.email
                           print("Email:  \(email ?? "error@gmail.com")************************")
                           print("Uid:  \(uid)*****************************")
                           }
                           
                           let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                           print("Name of textfield:  \(name ?? "Testing name field")**************")
                           changeRequest?.displayName = name
                           changeRequest?.commitChanges { (error) in
                            if error == nil {
                                print("Sucess upload display name!")
                                print("Uploaded display name:  \(user?.displayName ?? "NO NAME!!!!!!!!!!!")*************")
                                self.present((self.storyboard?.instantiateViewController(withIdentifier: "HomePage"))!, animated: true, completion: nil)
                                   
                            }
                            else{
                                print("Error to get the display name!")}
                           }
                    //====================================================================
            
                    
                  
                } else {
                    let alertController = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func BacktoMainPage(_ sender: Any) {
        if  Islogged_in == true  {
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "HomePage"))!, animated: true, completion: nil)}
    }
    
    }
    /*
     self.present(self.storyboard?.instantiateViewController(withIdentifier: "HomePage"), animated: true, completion: nil)
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
