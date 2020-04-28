//
//  RecordTableViewController.swift
//  CSFYP
//
//  Created by Hong Yuk Yu on 13/11/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RecordTableViewController: UITableViewController {

    let db = Firestore.firestore()
    //var counter:Int = 0
    var date = [String]()
    var result = [String] ()
    var LoadedData = false
    var RecordCounter: Int?
    var docRef : CollectionReference?
    var Ref: CollectionReference?
    
    @IBOutlet weak var Gif: UIImageView!
    let userid = Auth.auth().currentUser?.uid
    let username = Auth.auth().currentUser?.displayName
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "clean_background"))
        self.tableView.backgroundView?.alpha = 0.5
        Gif.loadGif(name: "loadingcat")
        /*let Ref =  self.db.collection("/BSRS5/Counter/Record")
        let docRef = Ref.document("Counter")

       docRef.getDocument { (document, error) in
             if let document = document, document.exists {
                self.RecordCounter = (document.get("DocNum") as! Int)
                print("DOCNUM!!!!!!\(String(describing: self.RecordCounter))")
                 // Do something with doc data
              } else {
                 print("Document does not exist")

              }
        }
         
         self.docRef = db.collection("BSRS5/").document("\(userid ?? "0")/test/Counter/Record")
               // Do any additional setup after loading the view.
               docRef?.getDocument { (document, error) in
                     if let document = document, document.exists {
                      // self.RecordCounter = self.docRef.count
                       
         
         self.docRef = db.collection("/BSRS5/\(userid ?? "0")/test/Counter/Record")
         Ref?.getDocuments(){ (querySnapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  self.RecordCounter = querySnapshot?.documents.count ?? 0
                  print("Video:\(self.videoNumber)")
         /BSRS5/\(userid ?? "0")/test/Counter/Record
         
         
         
         self.docRef = db.collection("/BSRS5/\(userid ?? "0")/test/Counter/Record")
                      Ref?.getDocuments(){ (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                           } else {
                               self.RecordCounter = querySnapshot?.documents.count ?? 0
                         print("DOCNUM!!!!!!\(String(describing: self.RecordCounter))")
                          // Do something with doc data
                       } else {
                          print("Document does not exist")

                       }
                 }
         
         db.collection("/BSRS5/\(userid ?? "0")/test/Counter/Record").get().then(snap => {
            elf.RecordCounter = snap.size // will return the collection size
         })
         */
        self.docRef = db.collection("/BSRS5/\(userid ?? "0")/test/Counter/Record")
             docRef?.getDocuments(){ (querySnapshot, err) in
                  if let err = err {
                      print("Error getting documents: \(err)")
                  } else {
                      self.RecordCounter = querySnapshot?.documents.count ?? 0
                print("DOCNUM!!!!!!\(String(describing: self.RecordCounter))")
                 // Do something with doc data
              }
        }
     
       
        
        //var counter = 0
        self.Ref = db.collection("/BSRS5/\(userid ?? "0")/test/Counter/Record")
        Ref?.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents  {
                  // print("Index: \(self.counter)")
                    //print(document.get("Year") ?? "2019")
                   
                    self.date.append("\(document.get("Year") ?? "2019")年\(document.get("Month") ?? "1")月\(document.get("Day") ?? "1")日")
                   // print((document.get("Result") ?? "No result"))
                    self.result.append("\(document.get("Result") ?? "No result")")
                   //print("\(String(describing: document.get("Score")))")
                  
                    }
                     
                }
            }
           
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.LoadedData = true
        self.tableView.reloadData()
        self.Gif.isHidden = true
        }
        
       
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print((self.counter))
        //return counter
        return  RecordCounter ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)as? TableViewCell
        
        if LoadedData == true{
        cell?.Date.text = "\(date[indexPath.row])"
        print("Index path row:  \(indexPath.row)")
        print("Date text =  \(date[indexPath.row])")
        cell?.Result.text = "\(result[indexPath.row])"
        print("Result text =  \(result[indexPath.row])")
        }
         
        return cell ?? tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}



