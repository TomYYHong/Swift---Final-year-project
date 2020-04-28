//
//  BSRS5Result.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 1/11/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class BSRS5Result: UIViewController {
    
    var Score: Int?
    var Q6option: Int?
    var RecordCounter: Int?

    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var ResultText: UILabel!
    
    
    let db = Firestore.firestore()
    var ResultString=""
    var docRef : DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Score!)
        print(Q6option!)
        
        Result.text = ("總分： \(Score ?? 0) 分")
        printInformation()
    }
    
    
    func printInformation(){
        if self.Score ?? 0 <= 5 && self.Q6option ?? 0 < 2 {
            ResultString = "你嘅身心障礙狀況良好!"
           print(ResultString)
            ResultText.text = ResultString
            
           }
        else if self.Score ?? 6 <= 9 && self.Score ?? 6 >= 6 && self.Q6option ?? 0 < 2{
            ResultString = "你受到輕度情緒困擾，建議搵人傾訴吓去獲得情緒支持!"
             print(ResultString)
             ResultText.text = ResultString
        }
        else if self.Score ?? 10 <= 14 && self.Score ?? 10 >= 10 && self.Q6option ?? 0 < 2{
            ResultString = "你受到中度情緒困擾，建議轉介精神科治療或接受專業諮詢!"
            print(ResultString)
             ResultText.text = ResultString
        }
        else{
            ResultString = "你受到重度情緒困擾，建議轉介精神科治療或接受專業諮詢!"
            print(ResultString)
            ResultText.text = ResultString
        }
    }
   
    @IBAction func UploadRecord(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "上載紀錄", message: "上載紀錄？", preferredStyle: .alert)
        let userid = Auth.auth().currentUser?.uid
        let username = Auth.auth().currentUser?.displayName
        
        self.docRef = db.collection("BSRS5").document("\(userid ?? "0")/test/Counter")
        // Do any additional setup after loading the view.
        docRef?.getDocument { (document, error) in
              if let document = document, document.exists {
                 self.RecordCounter = (document.get("DocNum") as! Int)
                 print("DOCNUM!!!!!!\(String(describing: self.RecordCounter))")
                  // Do something with doc data
               } else {
                  print("Document does not exist")

               }
         }
        
        
        let okAction = UIAlertAction(title: "好", style: .default) {(_) in
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
            self.db.collection("/BSRS5/").document("\(userid ?? "0")/test/Counter/Record/\((self.RecordCounter ?? 100)+1)").setData(["Year":year , "Month":month, "Day":day, "Score":self.Score ?? 0,"Q6":self.Q6option ?? 0, "Result": self.ResultString]) { err in
        if let err = err {
           print("Error writing document: \(err)")
        } else {
            let Uploadcontroller = UIAlertController(title: "成功上載!", message: "\(year)年\(month)月\(day)日嘅紀錄已經上載咗啦！ ", preferredStyle: .alert)
            self.docRef?.setData(["DocNum": (self.RecordCounter ?? 100)+1])
            let UploadAction = UIAlertAction(title: "好", style: .default, handler: nil)
            Uploadcontroller.addAction(UploadAction)
            self.present(Uploadcontroller, animated: true, completion: nil)
            }
            
        }
            
    }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
}

    

}

