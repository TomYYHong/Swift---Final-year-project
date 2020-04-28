//
//  ViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 23/10/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var Mainbaground: UIImageView!
    @IBOutlet weak var MainGIFItem: UIImageView!
    @IBOutlet weak var Logout: UIButton!
    @IBOutlet weak var UserIcon: UIImageView!
    
    @IBOutlet weak var Displayname: UILabel!
      var image: UIImage?
    
    let db = Firestore.firestore()
       let storage = Storage.storage()
       let userid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var URLstring = ""
        
        Mainbaground.loadGif(name:"gifitem3")
        MainGIFItem.loadGif(name: "gifitem")
         if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser?.displayName
           
            Displayname.text = "歡迎使用依個程式呀 \(user ?? "Nobody") "
        }
          db.document("icon/\(self.userid ?? "0")").getDocument  { (document, error) in
                 if let document = document, document.exists {
                  print("exist")
                  URLstring = document.get("ImageURL") as? String ?? ""
                  print(URLstring)
                  let url = NSURL(string: URLstring)! as URL
                          if let imageData: NSData = NSData(contentsOf: url) {
                              self.image = UIImage(data: imageData as Data)
                          }
                  self.UserIcon.image = self.image
                 } else {
                    print("Document does not exist")
                 }
              }
    }

    @IBAction func LogoutAction(_ sender: Any) {
        if Auth.auth().currentUser != nil {
               do {
                try Auth.auth().signOut()
                   self.present((self.storyboard?.instantiateViewController(withIdentifier: "LoginMain"))!, animated: true, completion: nil)
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
           }
    }
    
}

