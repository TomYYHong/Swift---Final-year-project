//
//  HelperViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 16/3/2020.
//  Copyright © 2020 Hong Yuk Yu. All rights reserved.
//

import UIKit
import WebKit

class HelperViewController: UIViewController {
   
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Address: UILabel!

    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var Webview: WKWebView!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var District: UILabel!
    @IBOutlet weak var Area: UILabel!
    @IBOutlet weak var Tel: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Website: UILabel!
    var websiteURL:String = ""
    var googlemapWebsite:String = ""
    var DetailHelper:Helper = Helper(name: "", address: "", district: "", area: "", location: "", tel: "", time: "", website: "")
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackButton.isHidden = true
        Webview.isHidden = true
        Name.text = DetailHelper.Name
        Address.text = DetailHelper.Address
        District.text = DetailHelper.District
        Area.text = DetailHelper.Area
        Tel.text = DetailHelper.Tel
        Time.text = DetailHelper.Time
        self.websiteURL = DetailHelper.Website
        Website.text = self.websiteURL
        googlemapWebsite = DetailHelper.Location
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mountain4")!)
       //self.view.backgroundColor?.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func GotoWebsite(_ sender: Any) {
      
        let websiteViewURL = URL(string: self.websiteURL)!
        let request = URLRequest(url: websiteViewURL)

        //self.Webview.load(request)
        UIApplication.shared.open(websiteViewURL)
   
    }
    
    @IBAction func GotoGoogleMap(_ sender: Any) {
        Webview.isHidden = false
        BackButton.isHidden = false
        let LocURL = URL(string: self.googlemapWebsite)
        //UIApplication.shared.open(LocURL!)
        self.Webview.load(URLRequest(url: LocURL!))
        self.Webview.allowsBackForwardNavigationGestures = true
    }
    

    @IBAction func Back(_ sender: Any) {
        self.Webview.isHidden = true
        self.BackButton.isHidden = true
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
