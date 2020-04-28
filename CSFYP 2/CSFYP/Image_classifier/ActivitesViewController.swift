//
//  ActivitesViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 19/3/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import NaturalLanguage


class ActivitesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var ImageView: UIImageView!
    
    
    @IBOutlet weak var EnterButton: UIButton!
    
    @IBOutlet weak var Textanalysis: UITextView!
    @IBOutlet weak var textsentiment: UIImageView!
    @IBOutlet weak var NewActivity: UITextField!
    @IBOutlet weak var OptionsTable: UITableView!
    @IBOutlet weak var OptionShowButton: UITableView!
    @IBOutlet weak var SelectActivity: UIButton!
    @IBOutlet weak var Activities: UITableView!
    @IBOutlet weak var Uploadimage: UIImageView!
    var result:String = ""
    var textreuslt:String = ""
    var textString: String = ""
   
    @IBOutlet weak var LoadingGif: UIImageView!
    
    @IBOutlet weak var ResultLabel: UILabel!
    var Selectedlist: [String] = []
     var OptionList: [String]  = []
    
         let db = Firestore.firestore()
 
         let storage = Storage.storage()

     let userid = Auth.auth().currentUser?.uid
     let username = Auth.auth().currentUser?.displayName
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docRef = self.db.collection("/Record/FavActivity/\(userid ?? "0")").document("Activity")
        docRef.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                        print("Document data: \(document.data())")
                        self.OptionList = document.get("Favlist") as! [String]
                        self.OptionsTable.reloadData()
                    } else {

                    print("Document does not exist")
                    self.OptionList = ["行山", "同朋友食飯", "睇戲", "野餐", "跑步", "打波", "打麻雀"]
                        self.OptionsTable.reloadData()


                    }
                }
            }
    
        LoadingGif.loadGif(name: "uploadcat")
        LoadingGif.isHidden = true
        
        OptionsTable.isHidden = true
        Uploadimage.image = ImageView.image
        Activities.dataSource = self
        Activities.delegate = self
        print("Result is \(result)")
        switch (result) {
        case ("Positive") : self.ResultLabel.text = "結果：  😀" ;
        case ("Neutral") : self.ResultLabel.text = "結果： 🙂" ;
        case ("Negative") : self.ResultLabel.text = "結果： ☹️" ;
        default:
            print("Result error!")
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func ClickOption(_ sender: Any) {
        if OptionsTable.isHidden {
                   animate(toogle: true, type: SelectActivity)
               } else {
            animate(toogle: false, type:
                SelectActivity)
               }
    }
    
    @IBAction func FinishedEntering(_ sender: Any) {
        if self.Textanalysis.text.isEmpty != true{
            textAnalyse(message: self.Textanalysis.text)
        }
        else{
            print("TextView is empty!")
        }
    }
    
    @IBAction func AddNewAcitivity(_ sender: Any) {
        if self.NewActivity.text!.isEmpty  == false {
            self.Selectedlist.append(self.NewActivity.text!)
          self.Activities.reloadData()
       } else {
          let controller = UIAlertController(title: "未有輸入活動！", message: "你仲未輸入活動呀！", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
          controller.addAction(okAction)
          present(controller, animated: true, completion: nil)
       }
    }
    
    
    func animate(toogle: Bool, type: UIButton) {
        
        
        if toogle {
            UIView.animate(withDuration: 0.3) {
            self.OptionsTable.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
            self.OptionsTable.isHidden = true
            }
        }

    }
    
    
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        var NumberOfRow = 0
           switch tableView {
           case OptionsTable: print("Now is Option table!")
           return OptionList.count
           
            
           
           case Activities: print("Now is Activity table!")
           return Selectedlist.count
            
               
           default:
               break
           }
           return NumberOfRow
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
           switch tableView {
           case Activities:
              let  Actcell = Activities.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath as IndexPath) as! ActivityCell
           Actcell.Label.text = Selectedlist[indexPath.row]
           return Actcell
           
               
           case OptionsTable:
              let Optcell = OptionsTable.dequeueReusableCell(withIdentifier: "OOO", for: indexPath as IndexPath) as! OptionCell
           Optcell.Label.text = OptionList[indexPath.row]
           return Optcell
        
            
           default:
               break
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       switch tableView {
        case OptionsTable:
            SelectActivity.setTitle("\(OptionList[indexPath.row])", for: .normal)
        animate(toogle: false, type: SelectActivity)
        self.Selectedlist.append(OptionList[indexPath.row])
        self.Activities.reloadData()
        break
        
       default:
                  break
        
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        switch tableView {
        case OptionsTable: OptionList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case Activities:  Selectedlist.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .automatic)
       
        
        default:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    
    
    @IBAction func UploadResult(_ sender: Any) {
        
        var downloadUrl = ""
        
                 //select to upload record or not
                    let controller = UIAlertController(title: "上載紀錄", message: "上載紀錄？", preferredStyle: .alert)
                    
                    //if confirmed to upload record
                    let okAction = UIAlertAction(title: "好", style: .default) {(_) in
                    let now = Date()
                    let calendar = Calendar.current
                    let year = calendar.component(.year, from: now)
                    let month = calendar.component(.month, from: now)
                    let day = calendar.component(.day, from: now)
                   self.LoadingGif.isHidden = false
                        
                        let set = Set(self.OptionList)
                        let union = set.union(self.Selectedlist)
                        let Favlist = Array(union)

                        print(Favlist)
                    
                        
                        //update today's record to firebase"
                        
                        //upload image to storage first
                         //set up image storage reference
                        let storageRef = self.storage.reference()
                        let imagesRef = storageRef.child("Record/\(self.userid ?? "000")/\(year)\(month)\(day)")
                        
                        //convert image to date, and send to storage
                        if  let uploadDate = self.Uploadimage.image!.jpegData(compressionQuality: 0.75){
                            imagesRef.putData(uploadDate, metadata: nil) { (metadata, error) in
                                if error != nil{
                                    print("ERRRRRRRROR!!!!:\(String(describing: error))")
                                    return
                                }
                        
                                //get the downloadURL and store it into the firestore
                                imagesRef.downloadURL { (url, error) in
                                  guard let URL = url else {
                                    print("Failed to get the download URL!")
                                    return
                                  }
                                    
        //********************************************************************************************************************
        //Needed to wait the firestorage to feeedback the download Url, so it takes time, and must wait for the download URL,and then upload the label and URL, otherwise the imageUrl will be null!!!!!
        //********************************************************************************************************************
                                    
                                    //wait for the url returned from cloud storage
                                    downloadUrl = URL.absoluteString
                                    print("DownloadURL:\(downloadUrl)")
                                   
                                    //upload label and imageUrl to firestore.
                                   
                                   
                                    self.db.collection("/Record/FavActivity/\(self.userid ?? "0")").document("Activity").setData(["Favlist" : Favlist])
                                    { err in
                                    if let err = err {
                                       print("Error writing document: \(err)")
                                    } else {
                                        print("Successfully upload list!")
                                        }
                                    }
                                
                                    let unique = Array(Set(self.Selectedlist))
                                    self.db.collection("Record/").document("\(self.userid ?? "0")/test/\(year)/\(month)/\(day)") .setData(["ImageURL":downloadUrl ,"Label": self.result , "RecordType": "Image", "Activites": unique , "Date": Int(day), "TextLabel": self.textreuslt, "Text": self.textString ]) { err in
                                        if let err = err {
                                           print("Error writing document: \(err)")
                                        } else {
                                            
                                            
                                            print("Document successfully written!")
                                            
                                            //inform user successfully upload
                                            let Uploadcontroller = UIAlertController(title: "成功上載!", message: "\(self.username ?? "用戶")你喺\(year)年\(month)月\(day)日嘅紀錄已經上載咗啦！ ", preferredStyle: .alert)
                                            
                                             
                                                self.LoadingGif.isHidden = true
                                               
                                               
                                        
                                            let UploadAction = UIAlertAction(title: "好", style: UIAlertAction.Style.default) {
                                              (action: UIAlertAction!) -> Void in
                                              self.dismiss(animated: true, completion: {
                                                                                                     self.presentingViewController?.dismiss(animated: true, completion: nil)
                                                                                                                                                })
                                            }
                                            Uploadcontroller.addAction(UploadAction)
                                            self.present(Uploadcontroller, animated: true, completion: nil)
                                            
                                           /* DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                  self.dismiss(animated: true, completion: {
                                                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                                                                                                   })
                                            }*/
                                            }
                                    }
                            }
                        }
                        
                        }
                        }
                    
                    //print("上載紀錄 \(year) & \(month) ")
                    
                    //Alert OK and Cancel option
                    controller.addAction(okAction)
                    let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
                    controller.addAction(cancelAction)
                    present(controller, animated: true, completion: nil)
     
        
    }
    
    func textAnalyse(message: String){
        
            do {
                let TextDetector = MyTextClassifier2()
                    //MyTextClassifier1()
               
                let prediction = try TextDetector.prediction(text: message);
                self.textString = message
                self.textreuslt = prediction.label
                switch textreuslt {
                case "Positive": self.textsentiment.image = UIImage(named: "Positive")
                case "Negative": self.textsentiment.image = UIImage(named: "Negative")
                case "Neutral": self.textsentiment.image = UIImage(named: "Neutral")
                    
                default:
                    print("Image error to display text sentiment!")
                }
     
                
               
            } catch {
                fatalError("Failed to load Natural Language Model: \(error)")
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

 

