//
//  YoutubeVideoViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 28/12/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//
import WebKit
import UIKit

class YoutubeVideoViewController: UIViewController {

    var video:Video = Video(videokey: "", videotitle: "", collection: "")
    
    @IBOutlet weak var VideoTitle: UILabel!
    @IBOutlet weak var Videoplayer: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        VideoTitle.text = video.Title
        getVideo(videoKey: video.Key)
        // Do any additional setup after loading the view.
    }
    
    func getVideo(videoKey:String) {
        
        let url = URL(string: "https://www.youtube.com/embed/\(videoKey)")
        Videoplayer.load(URLRequest(url: url!))
        
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
