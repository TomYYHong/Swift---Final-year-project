//
//  YoutubeTableViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 28/12/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase

class YoutubeTableViewController: UITableViewController {

    //var videos:[Video] = []
    var video:Video = Video(videokey: "", videotitle: "", collection: "")
    let db = Firestore.firestore()
    var Ref: CollectionReference?
    var videoNumber = 0
    var CollectionNumber = 0
    //store the video of each collection
    var CollectionStoreVideo:[VideoList] = []
    var GotVideoNumber = 0
    
    @IBOutlet weak var Gif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Gif.loadGif(name: "jumpingcat")
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "clean_background"))
        self.tableView.backgroundView?.alpha = 0.5
        
       self.Ref = db.collection("/youtube")
       Ref?.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.videoNumber = querySnapshot?.documents.count ?? 0
                print("Video:\(self.videoNumber)")
                for document in querySnapshot!.documents  {
                    
                    let Gotvideo = Video(videokey: document.get("key") as! String,videotitle: document.get("title") as! String, collection: document.get("Collection") as! String)
                    //self.videos.append(Gotvideo)
                    self.GotVideoNumber += 1
                    var found = false
                    
                    
                    
                    //check whether have same collection video exist
                    for item in self.CollectionStoreVideo{
                        if item.Title == Gotvideo.Collection{
                              //store video into that collection
                            item.addVideo(Addmyvideo: Gotvideo)
                            //print("Found: \(item.Title) + \(item.TotalNum)")
                            found = true
                            break
                            }
                            
                        }
                
                    if found == false{
                       
                        let buffer = VideoList.init(videokey: Gotvideo.Collection)
                        buffer.addVideo(Addmyvideo: Gotvideo)
                        self.CollectionStoreVideo.append(buffer)
                        
                        //print("Not found: \(Gotvideo.Collection)")
                    }
                    
                    if self.GotVideoNumber == self.videoNumber {
                        
                        self.tableView.reloadData()
                        self.Gif.isHidden = true
                    }
                    }
               /* print("Count: \(self.CollectionStoreVideo.count)")
                for item in self.CollectionStoreVideo{
                    print("Store:  \(item.Title) + \(item.Video)")
                }*/
                     
                }
        
            }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       if self.GotVideoNumber == 0 { return 1}
       else{ return self.CollectionStoreVideo.count}
       //return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("Title: \(self.CollectionStoreVideo[section].Title)")
        //return self.CollectionStoreVideo[section].Title
        if self.GotVideoNumber == 0 {return nil} else{
            print("Title: \(self.CollectionStoreVideo[section].Title)")
            return self.CollectionStoreVideo[section].Title
            
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if GotVideoNumber == 0{ return 0 }
        else{
        return self.CollectionStoreVideo[section].TotalNum
        }
        
        //return self.videoNumber
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeTableViewCell", for: indexPath) as! YoutubeTableViewCell
        
       
        
        
        let content = self.CollectionStoreVideo[indexPath.section].Video[indexPath.row]
        cell.YTtitile.text = content.Title
        let url = "https://img.youtube.com/vi/\(content.Key)/0.jpg"
        cell.YTimage.downloaded(from: url)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vi = self.CollectionStoreVideo[indexPath.section].Video[indexPath.row]
        self.video = vi
        
        performSegue(withIdentifier: "PlayVideo", sender: nil)
        
    }
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "PlayVideo" {
                
                let vc = segue.destination as! YoutubeVideoViewController
                vc.video = self.video
                
            }
            
        }
        
    }
    

class Video{
    var Key:String = ""
    var Title:String = ""
    var Collection:String = ""
    
    init(videokey:String,videotitle:String, collection:String) {
        self.Key = videokey
        self.Title = videotitle
        self.Collection = collection
    }
}

class VideoList{
    var Title:String = ""
    var Video:[Video] = []
    var TotalNum = 0
    
    init(videokey:String) {
        self.Title = videokey
    }
    func addVideo(Addmyvideo: Video){
        self.Video.append(Addmyvideo)
        TotalNum += 1
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
