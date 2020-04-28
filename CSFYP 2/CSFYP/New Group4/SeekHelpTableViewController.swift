//
//  SeekHelpTableViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 16/3/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase

class SeekHelpTableViewController: UITableViewController
{
   
   
           
    
    var HKIHelper:[Helper] = []
    var KLHelper:[Helper] = []
    var NTHelper:[Helper] = []
    let db = Firestore.firestore()
    var RefHKI: CollectionReference?
    var RefKL: CollectionReference?
    var RefNT: CollectionReference?
    var helpercount = 0
    var HelperBuffer:Helper = Helper(name: "", address: "", district: "", area: "", location: "", tel: "", time: "", website: "")
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var LoadingGif: UIImageView!
    
    open var hidesSearchBarWhenScrolling: Bool = false
    
    var searchHKI = [Helper]()
    var searchKL = [Helper]()
    var searchNT = [Helper]()
    

    
     var searching = false
    
    /*func updateSearchResults(for searchController: UISearchController) {
        searchHKI = [Helper]()
        searchKL = [Helper]()
        searchNT = [Helper]()
        let searchString = searchController.searchBar.text!
        print("String: \(searchString)")
        for element in HKIHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchHKI.append(element)
                print("HKI: \(searchHKI)")
            }
        }
        for element in KLHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchKL.append(element)
                 print("KL: \(searchKL)")
            }
        }
        for element in NTHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchNT.append(element)
                 print("NT: \(searchNT)")
            }
        }
        tableView.reloadData()
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self
       

    
        
        self.tableView.allowsSelection = true
        LoadingGif.loadGif(name: "catLoading")
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "mountain5"))
        self.tableView.backgroundView?.alpha = 0.5
        
         self.RefHKI = db.collection("/ServiceInform/Test/HKI")
         
        RefHKI?.getDocuments(){ (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.helpercount += querySnapshot?.documents.count ?? 0
           // print("helpercount:\(self.helpercount)")
            for document in querySnapshot!.documents  {
                let newhelper = Helper(name: document.get("Name") as! String, address: document.get("Address") as! String, district: document.get("District")
                    as! String, area: document.get("Area") as! String,location: document.get("Location") as! String, tel: document.get("Tel") as! String, time: document.get("Time") as! String, website: document.get("Website") as! String)
                self.HKIHelper.append(newhelper)
                
                print("HKIHelper: \(newhelper.Area) + \(newhelper.District)")
                self.tableView.reloadData()
            }
           
            }
        }
                
         self.RefKL = db.collection("/ServiceInform/Test/KL")
        RefKL?.getDocuments(){ (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.helpercount += querySnapshot?.documents.count ?? 0
           // print("helpercount:\(self.helpercount)")
            for document in querySnapshot!.documents  {
                let newhelper = Helper(name: document.get("Name") as! String, address: document.get("Address") as! String, district: document.get("District")
                    as! String, area: document.get("Area") as! String,location: document.get("Location") as! String, tel: document.get("Tel") as! String, time: document.get("Time") as! String, website: document.get("Website") as! String)
                self.KLHelper.append(newhelper)
                print("KLHelper: \(newhelper.Area) + \(newhelper.District)")
                self.tableView.reloadData()
            }
           
            }
        }
         self.RefNT = db.collection("/ServiceInform/Test/NT")
        RefNT?.getDocuments(){ (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.helpercount += querySnapshot?.documents.count ?? 0
            //print("helpercount:\(self.helpercount)")
            for document in querySnapshot!.documents  {
                let newhelper = Helper(name: document.get("Name") as! String, address: document.get("Address") as! String, district: document.get("District")
                    as! String, area: document.get("Area") as! String,location: document.get("Location") as! String, tel: document.get("Tel") as! String, time: document.get("Time") as! String, website: document.get("Website") as! String)
                self.NTHelper.append(newhelper)
                print("NTHelper: \(newhelper.Area) + \(newhelper.District)")
                self.tableView.reloadData()
                }
                 
            }
            }
       
      
            //self.LoadingGif.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                  self.LoadingGif.isHidden = true
            
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching  {
            if section == 0 {
                    print("section 1 number: \(searchHKI.count)")
                    return searchHKI.count
                    
                
                    
                }
                else if section == 1{
                    print("section 2 number: \(searchKL.count)")
                     return searchKL.count
            
            
                }
                else {
                   print("section 3 number: \(searchNT.count)")
                    return searchNT.count
                    
                    
                    }
        }
        else{
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
           // print("section 1 number: \(HKIHelper.count)")
            return HKIHelper.count
            
        
            
        }
        else if section == 1{
            //print("section 2 number: \(KLHelper.count)")
             return KLHelper.count
    
    
        }
        else {
           // print("section 3 number: \(NTHelper.count)")
            return NTHelper.count
            
            
            }
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelperCell", for: indexPath) as! CellofSeekHelp
        cell.accessoryType = .disclosureIndicator
        
        if searching  {
            if indexPath.section == 0 {
                       cell.Name.text = searchHKI[indexPath.row].Name
                       cell.District.text = searchHKI[indexPath.row].District
                       cell.Area.text = searchHKI[indexPath.row].Area
                   }else if indexPath.section == 1{
                       cell.accessoryType = .disclosureIndicator
                       cell.Name.text = searchKL[indexPath.row].Name
                       cell.District.text = searchKL[indexPath.row].District
                       cell.Area.text = searchKL[indexPath.row].Area
                   }else{
                       cell.accessoryType = .disclosureIndicator
                       cell.Name.text = searchNT[indexPath.row].Name
                       cell.District.text = searchNT[indexPath.row].District
                       cell.Area.text = searchNT[indexPath.row].Area
                   }
        }
        else{
        if indexPath.section == 0 {
            cell.Name.text = HKIHelper[indexPath.row].Name
            cell.District.text = HKIHelper[indexPath.row].District
            cell.Area.text = HKIHelper[indexPath.row].Area
        }else if indexPath.section == 1{
            cell.accessoryType = .disclosureIndicator
            cell.Name.text = KLHelper[indexPath.row].Name
            cell.District.text = KLHelper[indexPath.row].District
            cell.Area.text = KLHelper[indexPath.row].Area
        }else{
            cell.accessoryType = .disclosureIndicator
            cell.Name.text = NTHelper[indexPath.row].Name
            cell.District.text = NTHelper[indexPath.row].District
            cell.Area.text = NTHelper[indexPath.row].Area
        }
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
               if section == 0 {
                   title = "港島"
               }else if section == 1 {
                   title = "九龍"
               }else {
                   title = "新界"
               }
               return title
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ClickedHelper = Helper(name: "", address: "", district: "", area: "", location: "", tel: "", time: "", website: "")
        if searching  {
            
                   if indexPath.section == 0{
                   ClickedHelper = searchHKI[indexPath.row]
                   } else if indexPath.section == 1{
                       ClickedHelper = searchKL[indexPath.row]
                   }
                   else{
                       ClickedHelper = searchNT[indexPath.row]
                       
                   }
        }
        else{
        
        if indexPath.section == 0{
        ClickedHelper = HKIHelper[indexPath.row]
        } else if indexPath.section == 1{
            ClickedHelper = KLHelper[indexPath.row]
        }
        else{
            ClickedHelper = NTHelper[indexPath.row]
            
        }
        }
        HelperBuffer = ClickedHelper
        performSegue(withIdentifier: "SelectHelper", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               
               if segue.identifier == "SelectHelper" {
                   
                   let vc = segue.destination as! HelperViewController
                vc.DetailHelper = self.HelperBuffer

               }
               
           }


}

class Helper{
    var Name:String = ""
    var Address:String = ""
    var District:String = ""
    var Area:String = ""
    var Location:String = ""
    var Tel:String = ""
    var Time:String = ""
    var Website:String = ""

    init(name:String,address:String,district:String,area:String,
         location:String,tel:String,time:String,website:String) {
    self.Name = name
    self.Address = address
        self.District = district
        self.Area = area
        self.Location = location
        self.Tel = tel
        self.Time = time
        self.Website = website
}
}

extension SeekHelpTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchHKI = [Helper]()
        self.searchKL = [Helper]()
        self.searchNT = [Helper]()
        let searchString = SearchBar.text!
        print("String: \(searchString)")
        for element in HKIHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchHKI.append(element)
                print("HKI: \(searchHKI)")
            }
        }
        for element in KLHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchKL.append(element)
                 print("KL: \(searchKL)")
            }
        }
        for element in NTHelper{
            if element.Name.contains(searchString) || element.Address.contains(searchString) || element.Area.contains(searchString) || element.District.contains(searchString){
                searchNT.append(element)
                 print("NT: \(searchNT)")
            }
        }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
