//
//  SideMenu.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 12/3/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SideMenu: UIViewController,UINavigationControllerDelegate ,UIImagePickerControllerDelegate{
    @IBOutlet weak var UserIcon: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    
    //connect to firestore and storage
    @IBOutlet weak var loading: UIImageView!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let userid = Auth.auth().currentUser?.uid
   var image: UIImage?
    let user = Auth.auth().currentUser?.displayName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserIcon.image = UIImage(named: "usericon.png")
        var URLstring = ""
        loading.loadGif(name:"rainbow_Cat")
        loading.isHidden = true
        
        UserName.text = "名戶名稱：  \(user ?? "WHO?") ."
    
        //let docRef = self.db.collection("icon").document("\(self.userid ?? "0")")
        
        //URLstring = docRef.get("ImageURL") as! String
        
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
        // Do any additional setup after loading the view.
    

    @IBAction func ChangeIcon(_ sender: Any) {
    let userid = Auth.auth().currentUser?.uid
           let storageRef = self.storage.reference()
           let imagesRef = storageRef.child("Record/\(userid ?? "000")/icon")
        
    let imagePickerController = UIImagePickerController()
        let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
        

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                     
                     imagePickerController.delegate = self
                     imagePickerController.sourceType = .photoLibrary;
                     imagePickerController.allowsEditing = true
                     self.present(imagePickerController, animated: true, completion: nil)
                 }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
             
                      imagePickerAlertController.dismiss(animated: true, completion: nil)
                  }
             imagePickerAlertController.addAction(imageFromLibAction)
            
             imagePickerAlertController.addAction(cancelAction)
        
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    @IBAction func ChangeName(_ sender: Any) {
        var new_displayname = ""
        let controller = UIAlertController(title: "更改用戶用稱", message: "請輸入你想更改嘅名稱。", preferredStyle: .alert)
        controller.addTextField { (textField) in
           textField.placeholder = "新用戶名稱"
        }
        
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            new_displayname = (controller.textFields?[0].text)!
            if new_displayname == "" {
               let controller = UIAlertController(title: "空白輸入!", message: "請輸入新用戶名稱", preferredStyle: .alert)
               let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
               controller.addAction(okAction)
                self.present(controller, animated: true, completion: nil)
            }
            else {
           
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            print("New name: \(new_displayname)")
            changeRequest?.displayName = new_displayname
            changeRequest?.commitChanges { (error) in
                print("Displayname_error")
            }
            let upadated_displayname = Auth.auth().currentUser?.displayName
                self.UserName.text = "名戶名稱：  \(upadated_displayname ?? "WHO?") ."
            }
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    //upload user personal icon picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
      
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            let storage = Storage.storage()
            let db = Firestore.firestore()
            
            
           // let userid = Auth.auth().currentUser?.uid
              let storageRef = storage.reference()
              let imagesRef = storageRef.child("Record/\(userid ?? "000")/icon")
            loading.isHidden = false
            if let uploadData = selectedImage.pngData() {
        
                imagesRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {

                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    imagesRef.downloadURL { (url, error) in
                    guard let URL = url else {
                      print("Failed to get the download URL!")
                      return
                    }
                        
                    let uploadImageUrl = URL.absoluteString
                        
                        print("Photo Url: \(uploadImageUrl)")
                        
                         
                        self.db.collection("icon/").document("\(self.userid ?? "0")").setData(["ImageURL":uploadImageUrl]) { err in
                        if let err = err {
                           print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                           
                            
                            let url = NSURL(string: uploadImageUrl)! as URL
                            if let imageData: NSData = NSData(contentsOf: url) {
                                self.image = UIImage(data: imageData as Data)
                                self.UserIcon.image = self.image
                                self.loading.isHidden = true
                            }
                            }
                        }
                    }
                }
            )
        }
                        
                    }
        
        dismiss(animated: true, completion: nil)
    }


}

