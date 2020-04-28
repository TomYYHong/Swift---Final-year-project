//
//  ChangePasswordViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 12/1/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var email2: UITextField!
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var ChangePWButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil{
            BackButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ChangePassword(_ sender: Any) {

        if self.email.text == "" || self.email2.text == "" {
            let alertController = UIAlertController(title: "錯誤!", message: "請輸入電郵地址.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else if self.email.text?.elementsEqual(self.email2.text!) == false {
            let alertController = UIAlertController(title: "錯誤!", message: "請再次輸入電郵地址.", preferredStyle: .alert)
                       
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);alertController.addAction(defaultAction)
                       
            present(alertController, animated: true, completion: nil)
        }
        else {
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
            
            var title = ""
            var message = ""
            
            if error != nil {
                title = "錯誤!"
                message = (error?.localizedDescription)!
            } else {
                title = "成功!"
                message = "已寄出重設密碼電郵."
                self.email.text = ""
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }

        )}
        
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
