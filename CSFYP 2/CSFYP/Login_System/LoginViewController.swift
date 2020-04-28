//
//  LoginViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 10/1/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var ChangePassword: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                   
                     let uid = user.uid
                     let email = user.email
                    print("Logged in with:  ")
                   print("Email:  \(email ?? "error@gmail.com")************************")
                   print("Uid:  \(uid)*****************************")
                   }
            
        
        }else {print("No logged in!!!")}
        
        
        if Auth.auth().currentUser != nil {
           /* do {
                try Auth.auth().signOut()
                print("LOGGED OUT****")
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }*/
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "HomePage"))!, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func Login(_ sender: Any) {
        if self.Email.text == "" || self.Password.text == "" {

            
            let alertController = UIAlertController(title: "有嘢錯咗！", message: "請輸入你嘅電郵地址同埋密碼！", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            
            Auth.auth().signIn(withEmail: self.Email.text!, password: self.Password.text!) { (user, error) in
                
                if error == nil {
                    

                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    

                    let alertController = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
