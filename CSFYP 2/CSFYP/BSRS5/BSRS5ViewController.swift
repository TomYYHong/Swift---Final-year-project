//
//  BSRS5ViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 1/11/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit

class BSRS5ViewController: UIViewController {
    @IBOutlet weak var Q1Ans: UISegmentedControl!
    @IBOutlet weak var Q2Ans: UISegmentedControl!
    @IBOutlet weak var Q3Ans: UISegmentedControl!
    @IBOutlet weak var Q6Ans: UISegmentedControl!
    @IBOutlet weak var Q5Ans: UISegmentedControl!
    @IBOutlet weak var Q4Ans: UISegmentedControl!
    
    @IBOutlet weak var CheckResultButton: UIButton!
    
    var Score = 0
    var QOption = [0,0,0,0,0,0]
    var Q6option = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Score = 0
        // Do any additional setup after loading the view.
    }
    @IBAction func Q1Act(_ sender: UISegmentedControl) {
        QOption[0] = sender.selectedSegmentIndex
    }
    @IBAction func Q2Act(_ sender: UISegmentedControl) {
         QOption[1] = sender.selectedSegmentIndex
    }
    @IBAction func Q3Act(_ sender: UISegmentedControl) {
        QOption[2] = sender.selectedSegmentIndex
    }
    @IBAction func Q4Act(_ sender: UISegmentedControl) {
         QOption[3] = sender.selectedSegmentIndex
    }
    @IBAction func Q5Act(_ sender: UISegmentedControl) {
         QOption[4] = sender.selectedSegmentIndex
    }
    @IBAction func Q6Act(_ sender: UISegmentedControl) {
         QOption[5] = sender.selectedSegmentIndex
    }
    
    
    func AddScore(option: Int){
        let recievedValue = option
        switch recievedValue {
        case 1: Score += 1
        case 2: Score += 2
        case 3: Score += 3
        case 4: Score += 4
        case 5: Score += 5
            
        default:
            print("Test!")
        }
    }

    @IBAction func ChecKResult(_ sender: UIButton) {
        QOption.forEach { option in
            AddScore(option: option)
            print(option)
        }
        Q6option = QOption[5]
        print("Score:\(Score)")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //if segue.identifier == "BSRS5ToResult"{
            let controller = segue.destination as? BSRS5Result
        controller?.Q6option = self.Q6option
        controller?.Score = self.Score
        Score = 0
       // }
    }
    

}
