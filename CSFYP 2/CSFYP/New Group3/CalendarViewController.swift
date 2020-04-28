//
//  CalendarViewController.swift
//  CSFYP
//
//  Created by Yuk Yu Hong on 27/10/2019.
//  Copyright © 2019 Hong Yuk Yu. All rights reserved.
//

import UIKit
import Firebase
import Charts
import FirebaseAuth

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String{
        let buffer:[String] = self.FavActivities
        
        return buffer[Int(value) % buffer.count]
        //print("buffer: \(buffer.count)")
        //print("Value: \(value)")
        //print(buffer[Int(value) % buffer.count])
        //let Bvalue = Int(value)
        //print(Bvalue)
       // print("buffer: Int: \(buffer[Int(value)])")
        
       /* if Bvalue >= 0 && Bvalue < buffer.count {
               return buffer[Int(value)]
           }
           
           return ""*/
           
        //return buffer[Int(value)]

      
    }
    

    
    
    

    @IBOutlet weak var RadarChart: RadarChartView!
    @IBOutlet var MainView: UIView!

    @IBOutlet weak var NegativeActivites: UILabel!
    @IBOutlet weak var PostiveActivites: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var MonthlyCount: UILabel!
    
    
    let db = Firestore.firestore()
    
    
    //Calendar Object
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
    var NumberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year: currentYear , month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear , month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    var howManyItemsShouldIAdd:Int{
        return whatDayIsIt - 1
    }
    
    
    //counter
    var EachMonthDateWithRecord = [String]()
    var LabelArray = [String]()
    
    
    
    //pie chart
    var NegativeCount = PieChartDataEntry(value: 0)
    var PositiveCount = PieChartDataEntry(value: 0)
    var NeutralCount = PieChartDataEntry(value: 0)
    var numberOfTotalRecord = [PieChartDataEntry]()
    
    //User inform
    let username = Auth.auth().currentUser?.displayName
    let userid = Auth.auth().currentUser?.uid
    
    //FavAct Object
    var Activties2DArray = FavActiviteList()
    var FavActivities:[String] = []
    var PerFavActivities:[String] = []
    var totalCount = 0
 
    //UIView Object
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var LastMonth: UIButton!
    @IBOutlet weak var NextMonth: UIButton!
    @IBOutlet weak var Background: UIImageView!
    @IBOutlet weak var LoadingGIF: UIImageView!
    
    //Date object
    var DateArray:[Dates] = []
    var PNN :[Int] = [0,0,0]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingGIF.loadGif(name:"loading")
       
        self.MainView.backgroundColor = UIColor(patternImage: UIImage(named: "Mountain7")!)
    
//**********************************************************************************************
        //load records from cloud database
       // ReloadDate()
  
        
        //,正面：\(self.PositiveCount)項；中性:\(self.NeutralCount)項；負面：\(self.NegativeCount)項
//----------------------------------------------------------------------------------------
           //Obatin User's Favorite Acitivity list
                /* db.collection("Record/FavActivity/\(userid ?? "0")").document("Activity").getDocument{ (document, error) in
                           if let document = document, document.exists {
                               self.FavActivities = document.get("Favlist") as! [String]
                            self.PerFavActivities = self.FavActivities
                            print("FavActivities : \(self.FavActivities)")
                           }else{
                               print("Favlist not exist!")
                               }
                              
                           }*/
        
//-------------------------------------------------------------------------------------
         
           
          
          //self.RadarChart.data = nil
        ReloadFavAct()
          ReloadDate()
        
         //ReloadFavAct()
        //setupPieChart()
       }
    
    
    
    //***********************************************************************************
    //Build Collection View Table thus establish calendar
    
    
   func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NumberOfDaysInThisMonth + howManyItemsShouldIAdd
    }
    
    var ArrayElementNumber = 0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"cell", for: indexPath) as! DateCell
        

        
        if let textlabel = cell.Label{
           // let  textlabel2 = cell.contentView.subviews[1] as? UILabel
            if indexPath.row < howManyItemsShouldIAdd{
                textlabel.text = ""
            }
            else{
                
                let dateOfCell = (indexPath.row + 1 - howManyItemsShouldIAdd)
                textlabel.text = "\(dateOfCell)"
            }

            
        }
        
        if let cellimage = cell.Image{
            
             cellimage.image = UIImage(named: "Empty")
            if indexPath.row < howManyItemsShouldIAdd{
                          //print("show nothing!")
                       }
                       else{
                           
                           let imageOfCell = (indexPath.row + 1 - howManyItemsShouldIAdd)
                for item in DateArray{
                                           if item.Date == imageOfCell {
                                               switch item.label {
                                               case "Positive": cellimage.image = UIImage(named: "Positive") ;
                                               case "Negative": cellimage.image = UIImage(named: "Negative");
                                               case "Neutral": cellimage.image = UIImage(named: "Neutral") ;
                                               default:
                                                   print("something wired!");
                                               }
                                           }
                                       }
               // print("EachMonthDateWithRecord: \(EachMonthDateWithRecord)")
                          /* if EachMonthDateWithRecord.contains("\(imageOfCell)")
                           {
                       
                           // print("Now is \(imageOfCell) and record is found --- \(LabelArray[ArrayElementNumber] )")
                            //print("LabelArray: \(LabelArray) and \(LabelArray.count)")
                               switch LabelArray[ArrayElementNumber] {
                               case "Positive": cellimage.image = UIImage(named: "Positive") ;
                               case "Negative": cellimage.image = UIImage(named: "Negative");
                               case "Neutral": cellimage.image = UIImage(named: "Neutral") ;
                               default:
                                print("something wired!");
                            }
                             
                               //print("\(ArrayElementNumber)")
                               ArrayElementNumber += 1
                           
                           }*/
                       }
        }

            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 60)
    }
  
    
    //Cell clicked action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var SelectedDate:Dates = Dates(Date: 0,RecordType: "",label: "",imageURLString: "",AlertActivites: [], Text: "", TextLabel: "")
        var HaveRecord = false
        let date = indexPath.row + 1 - howManyItemsShouldIAdd
        var AlertLabel = ""
        var AlertActivites:[String] = []
        var image: UIImage?
        
        LoadingGIF.loadGif(name:"loading")
        LoadingGIF.isHidden = false

  
        //Finding record which matched with the date
        for item in DateArray {
            print("Item date:  \(item.Date)  +  date:  \(date)")
            if item.Date == date{
                SelectedDate = item
                HaveRecord = true
                break
            }
        }
    
        
      
            print("Image exist: \(SelectedDate.RecordType)")
            if HaveRecord == true {
             
            if SelectedDate.RecordType == "Image" {
             
              
                
                 
                let alert = UIAlertController(title: "紀錄", message: "\(self.currentYear)年\(self.currentMonth)月\(date)日", preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .default, handler: nil)


                if let imageData: NSData = NSData(contentsOf: SelectedDate.ImageURL) {
                    image = UIImage(data: imageData as Data)
                }
                 // print("URL: \(SelectedDate.ImageURL)")
    
                AlertActivites = SelectedDate.Activites
                let fullScreenSize = UIScreen.main.bounds.size
                var testHeight = 0
                var testWidth = 0
                var ratio:Double = 0.0
                
                
               //print("!!width: \(Int(image?.size.width ?? 375)) and the height: \(Int(image?.size.height ?? 450))")
                if Int(image?.size.width ?? 150) >= 150{ ratio = Double(Int(image?.size.width ?? 150)/150); testWidth = 150 }
                //print("ratio: \(ratio) and the width:  \(testWidth)")
                if Int(image?.size.height ?? 300) >= 300{testHeight =  Int(image?.size.height ?? 300)/Int(ratio) }
                //print("Height: \(testHeight)")
                let imgViewTitle = UIImageView(frame: CGRect(x: 70, y: 200, width: testWidth, height: testHeight))
               
                
                imgViewTitle.image = image
                alert.view.addSubview(imgViewTitle)
               
                var ActivitesString = ""
                if AlertActivites.isEmpty == false{
                    for n in AlertActivites {
                        if n == AlertActivites.last{
                            ActivitesString += n
                        }
                        else{
                            ActivitesString += "\(n),"}
                    }
                    
                }
                /*let ActivitesTitledstext = UILabel(frame: CGRect(x: 30, y: 70, width: 300, height: 50))
                ActivitesTitledstext.text = "當日活動如下："
                alert.view.addSubview(ActivitesTitledstext)*/
                
                let Activitiestext = UILabel(frame: CGRect(x: 30, y: 70, width: 200, height: 70))
                 Activitiestext.text = "當日活動如下： \(ActivitesString)."
                Activitiestext.numberOfLines = 4
                
                alert.view.addSubview(Activitiestext)
                
                let Labeltext = UILabel(frame: CGRect(x: 30, y: 50, width: 200, height: 50))
    
                if SelectedDate.label == "Positive"{
                    AlertLabel = "正面"
                }else if SelectedDate.label == "Negative"{
                    AlertLabel = "負面"
                                      }
                    else if SelectedDate.label == "Neutral" {
                    AlertLabel = "中性"
                }
                Labeltext.text = "結果係：  \(AlertLabel)！"

                
                alert.view.addSubview(Labeltext)
             print("Labeltext Part!")
                
                let TextAnalysistext = UILabel(frame: CGRect(x: 30, y: 130, width: 200, height: 50))
                let TextAnalysistextLabel = UILabel(frame: CGRect(x: 30, y: 160, width: 200, height: 50))
                var bufferofText = ""
                if SelectedDate.textLabel == "Positive"{
                    bufferofText = "正面"
                }else if SelectedDate.textLabel == "Negative"{
                    bufferofText = "負面"
                                      }
                    else if SelectedDate.textLabel == "Neutral" {
                    bufferofText = "中性"
                }
                
                TextAnalysistext.text = "日記： \(SelectedDate.text)"
                TextAnalysistext.numberOfLines = 4
                
                TextAnalysistextLabel.text = "內容\(bufferofText)!"
                alert.view.addSubview(TextAnalysistext)
                alert.view.addSubview(TextAnalysistextLabel)
             
                //set the position of the alert view
                let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(Int(testHeight+250)))
                let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
                alert.view.addConstraint(height)
                alert.view.addConstraint(width)
                
                //alert.view.addSubview(imgViewTitle)
                //self.LoadingGIF.isHidden = true
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.LoadingGIF.isHidden = true
                    
                }
                
            }
           } else {
               print("Document does not exist")
            self.LoadingGIF.isHidden = true
            let controller = UIAlertController(title: "搵唔到紀錄!", message: "睇嚟你當日冇紀錄低喎", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "好", style: .default, handler: nil)

            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
           }
    }
    
    func ReloadFavAct(){
        if self.DateArray.count == 0 {
            self.FavActivities.removeAll()
        }
        else{
            self.FavActivities = self.PerFavActivities
        }
        print("Reload FA!")
        setUpRadarChart()
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendar.collectionViewLayout.invalidateLayout()
        calendar.reloadData()
    }

    
//Reload data
    func ReloadDate(){
        self.PNN = [0,0,0]
        let MonthRef = db.collection("Record/\(userid ?? "0")/test/\(currentYear)/\(currentMonth)")
               MonthRef.getDocuments(){ (querySnapshot, err) in
                   if err != nil {
                      print("Obtain Date file error!")
                       }
                   else{ for document in querySnapshot!.documents  {
                       self.totalCount += 1
                       let DLabel = document.get("Label") as? String ?? ""
                    
                    if DLabel == "Positive"{self.PNN[0] += 1 }else if DLabel == "Negative"{self.PNN[1] += 1 }else {self.PNN[2] += 1 }
                    
                       let DActivites = document.get("Activites") as? [String] ?? []
                       let DDate = document.get("Date") as? Int ?? 0
                    let DRecordType = document.get("RecordType") as? String ?? ""
                    let DImgaeURL = document.get("ImageURL") as? String ?? ""
                    let DText = document.get("Text") as? String ?? ""
                    let DTextLabel = document.get("TextLabel") as? String ?? ""
                    
                    self.LabelArray.append(DLabel)
                    self.EachMonthDateWithRecord.append(document.documentID)
                    self.DateArray.append(Dates(Date: DDate,  RecordType: DRecordType, label: DLabel, imageURLString: DImgaeURL,  AlertActivites: DActivites, Text: DText, TextLabel: DTextLabel))
                    
                    for item in DActivites{
                        if self.FavActivities.contains(item) == false{
                            self.FavActivities.append(item)
                            self.PerFavActivities = self.FavActivities
                            print("Delected FA: \(item) and now is : \(self.FavActivities)")
                        }
                    }
                    
                    self.Activties2DArray.addActivites(Label: DLabel, Activties: DActivites)
                    
                    
                    self.PostiveActivites.text = "與正面情緒相關嘅活動： \(self.Activties2DArray.commentFactor(label: "Positive"))"
                    self.NegativeActivites.text = "與負面情緒相關嘅活動： \(self.Activties2DArray.commentFactor(label: "Negative"))"
                    
                    //dump(self.LabelArray)
                    
                                          }
                     self.calendar.reloadData()
                  
                    
                   }
                
                 
                   
               }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.ReloadFavAct()
                 self.setupPieChart()
                 self.LoadingGIF.isHidden = true
             }
         
    }

    
//******************************************************************************************************************
    //Setup Chart!
   
    
    func setUpRadarChart(){
        
        var PosSortedActDict: [(key: String, value: Int)] = [("",0)]
        var NegSortedActDict: [(key: String, value: Int)] = [("",0)]
        var NeuSortedActDict: [(key: String, value: Int)] = [("",0)]
        let ActivityNumCount = self.FavActivities.count
        PosSortedActDict = self.Activties2DArray.Record(label: "Positive")
        NegSortedActDict = self.Activties2DArray.Record(label: "Negative")
        NeuSortedActDict = self.Activties2DArray.Record(label: "Neutral")
        
        var PosEnt:[ChartDataEntry] = []
        var NegEnt:[ChartDataEntry] = []
        var NeuEnt:[ChartDataEntry] = []
        
        PosEnt.removeAll()
        NegEnt.removeAll()
        NeuEnt.removeAll()
        
       
        //print("FA: \(self.FavActivities)")
        print("Act: \(ActivityNumCount)")
        if ActivityNumCount == 0{
            print("ActivitNum is 0!")
            self.RadarChart.data = nil
            //setUpRadarChart()
        }else{
        
        
                for i in 0...ActivityNumCount-1{
                    var pfound = false
                    var Negfound = false
                    var Neufound = false
                if PosSortedActDict.count != 0 {
                for j in 0...PosSortedActDict.count-1 {
                    if  Array(PosSortedActDict)[j].key ==  self.FavActivities[i] {
                        pfound = true
                        PosEnt.append(RadarChartDataEntry(value: Double(PosSortedActDict[j].value)))
                        //print("FA: \(i) +\(self.FavActivities[i]) ,\(j) -  PosDict: \(PosSortedActDict[j].key) + \(PosSortedActDict[j].value)")
                       // p += 1
                        // print("P\(p) with matched")
                        
                    }
                    }
                    if pfound == false{
                        PosEnt.append(RadarChartDataEntry(value: 0.0))
                        //p += 1
                        //print("P\(p) with not match")
                    }
                }else{
                    PosEnt.append(RadarChartDataEntry(value: 0.0))
                    //p += 1
                    //print("P\(p) with 0 count")
                    
                    }
                
                
                if NegSortedActDict.count != 0 {
                    for j in 0...NegSortedActDict.count-1 {
                        //print("NegSortedActDict[j] value : \(j) and \(NegSortedActDict.[j<#T#>])")
                        if Array(NegSortedActDict)[j].key ==  self.FavActivities[i]  {
                                          NegEnt.append(RadarChartDataEntry(value: Double(NegSortedActDict[j].value)))
                           //print("FA:\(i) + \(self.FavActivities[i]) , \(j) - NegDict: \(NegSortedActDict[j].key) + \(NegSortedActDict[j].value)")
                            Negfound = true
                            //eg += 1
                            // print("Neg\(eg) with matched")
                            
                    }
                }
                    if Negfound == false{
                NegEnt.append(RadarChartDataEntry(value: 0.0))
                //eg += 1
                        //print("Neg\(eg) with not match")
                        
                    }
                }else{
                    NegEnt.append(RadarChartDataEntry(value: 0.0))
                     //eg += 1
                    //print("Neg\(eg) with 0 count")
                }
                
                if NeuSortedActDict.count != 0 {
                    for j in 0...NeuSortedActDict.count-1 {
                                      if Array(NeuSortedActDict)[j].key ==  self.FavActivities[i] {
                                          NeuEnt.append(RadarChartDataEntry(value: Double(NeuSortedActDict[j].value)))
                                         // print("FA: \(i) +\(FavActivities[i]) ,\(j) -  NeuDict: \(NeuSortedActDict[j].key) + \(NeuSortedActDict[j].value)")
                                        Neufound = true
                                        //u += 1
                                       // print("NU\(u) with matched")
                                        
                                      }
                                  }
                    if Neufound == false{
                    NeuEnt.append(RadarChartDataEntry(value: 0.0))
                    //u += 1
                        //print("NU\(u) with not match")
                        
                    }
                }else{NeuEnt.append(RadarChartDataEntry(value: 0.0))
                     //u += 1
                   // print("NU\(u) with 0 count")
                }
            }
       // print("PE: \(PosEnt.count)")
       // print("NEG: \(NegEnt.count)")
        //print("Neu: \(NeuEnt.count)")
        
        self.RadarChart.webLineWidth = 2
        self.RadarChart.innerWebLineWidth = 2
        self.RadarChart.webColor = .lightGray
        self.RadarChart.innerWebColor = .lightGray

        
        let xAxis = self.RadarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 10
        xAxis.yOffset = 10
        

        
        xAxis.valueFormatter = self
       
        
        
        let yAxis = self.RadarChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        yAxis.labelCount = self.LabelArray.count
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.axisMinimum = 0
        yAxis.valueFormatter = YAxisFormatter()
    
       

        let greenDataSet = RadarChartDataSet(entries: PosEnt,label: "正面")
        let redDataSet = RadarChartDataSet(entries: NegEnt,label: "負面")
        let yellowDataSet = RadarChartDataSet(entries: NeuEnt,label: "中性")
        
        redDataSet.lineWidth = 1
        let redColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 1)
        let redFillColor = UIColor(red: 247/255, green: 67/255, blue: 115/255, alpha: 0.6)
        redDataSet.colors = [redColor]
        redDataSet.fillColor = redFillColor
        redDataSet.drawFilledEnabled = true
        
        greenDataSet.lineWidth = 1
        let greenColor = UIColor(red: 67/255, green: 247/255, blue: 115/255, alpha: 1)
        let greenFillColor = UIColor(red: 67/255, green: 247/255, blue: 115/255, alpha: 0.6)
        greenDataSet.colors = [greenColor]
        greenDataSet.fillColor = greenFillColor
        greenDataSet.drawFilledEnabled = true
        
         yellowDataSet.lineWidth = 1
        let YellowColor = UIColor(red: 255/255, green: 255/255, blue: 51/255, alpha: 1)
        let YellowFillColor = UIColor(red: 255/255, green: 255/255, blue: 51/255, alpha: 0.6)
        yellowDataSet.colors = [YellowColor]
        yellowDataSet.fillColor = YellowFillColor
        yellowDataSet.drawFilledEnabled = true
        
        redDataSet.valueFormatter = IndexAxisValueFormatter(values: self.FavActivities) as? IValueFormatter
        greenDataSet.valueFormatter = IndexAxisValueFormatter(values: self.FavActivities) as? IValueFormatter
        yellowDataSet.valueFormatter = IndexAxisValueFormatter(values: self.FavActivities) as? IValueFormatter
        
        redDataSet.valueFormatter = DataSetValueFormatter()
        
        let data = RadarChartData(dataSets: [greenDataSet, redDataSet,yellowDataSet])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.black)
        self.RadarChart.data = data
        
        }
    }
    
    
    
    func setupPieChart(){
        self.LoadingGIF.isHidden = false
        pieChart.centerText = "本月紀錄"
        pieChart.holeColor = UIColor(named:"Pie")
        pieChart.chartDescription?.text = "今月紀錄"
        pieChart.chartDescription?.font = .systemFont(ofSize: 18, weight: .bold)
        self.EachMonthDateWithRecord.removeAll()
        self.LabelArray.removeAll()
      
        NegativeCount.value = Double(self.PNN[1])
               NegativeCount.label = "負面"
               NeutralCount.value = Double(self.PNN[2])
               NeutralCount.label = "中性"
               PositiveCount.value = Double(self.PNN[0])
               PositiveCount.label = "正面"
        
        timeLabel.text = "\(currentYear)年" + months[currentMonth - 1 ]
        
        
        
    
       
            //print("Now is month \(currentMonth)!")
            //print("check db!")
        ArrayElementNumber = 0
         self.numberOfTotalRecord = [self.NegativeCount,self.NeutralCount,self.PositiveCount]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.MonthlyCount.text = "本月共有\(self.totalCount)項紀錄"
            self.updateChartData()
            self.LoadingGIF.isHidden = true
        }
        // calendar.reloadData()
}
    
    @IBAction func ClickLastMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
       
        self.DateArray.removeAll()
        self.Activties2DArray.reload()
        self.EachMonthDateWithRecord.removeAll()
        self.LabelArray.removeAll()
        self.totalCount = 0
         //self.RadarChart.data = nil
    
        ReloadDate()
        self.PostiveActivites.text = "與正面情緒相關嘅活動： 無相關記錄！"
        self.NegativeActivites.text = "與負面情緒相關嘅活動：無相關記錄！"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           //self.setUpRadarChart()
        }
        self.calendar.reloadData()
    }
    
    @IBAction func ClickNextMonth(_ sender: UIButton) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        
        self.DateArray.removeAll()
              self.Activties2DArray.reload()
              self.EachMonthDateWithRecord.removeAll()
              self.LabelArray.removeAll()
              self.totalCount = 0
         //self.RadarChart.data = nil

        ReloadDate()
        
        self.PostiveActivites.text = "與正面情緒相關嘅活動： 無相關記錄！"
        self.NegativeActivites.text = "與負面情緒相關嘅活動： 無相關記錄！"
        
        self.calendar.reloadData()
        
    }
    
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries:numberOfTotalRecord,label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        //chartDataSet.colors = ChartColorTemplates.colorful()
        let colors = [UIColor(named:"Red"),UIColor(named:"Yellow"),UIColor(named:"Green")]
       chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }
    
    


}



//_________________________________________________________________________________________________________________
//cutom objects



class FavActiviteList {

    var PosActivitesList: [[String]] = []
    var NegActivitesList: [[String]] = []
    var NeuActivitesList: [[String]] = []
    var PosSortedActDict: [(key: String, value: Int)] = [("",0)]
    var NegSortedActDict: [(key: String, value: Int)] = [("",0)]
    var NeuSortedActDict: [(key: String, value: Int)] = [("",0)]
    
    init() {
       // print("Create FavActivitesList Object!!!")
    }
    
    func addActivites(Label : String, Activties: [String]){
       
        switch Label {
        case "Positive":
            PosActivitesList.append(Activties)
            //print("Pos List:  \(PosActivitesList)")
            break
        case "Negative":
            NegActivitesList.append(Activties)
             //print("Pos List:  \(NegActivitesList)")
            break
        case "Neutral":
            NeuActivitesList.append(Activties)
            //print("Pos List:  \(NeuActivitesList)")
            break
        default:
            print("Can not add activites into list!")
        }
        
    }
    
    func commentFactor(label:String) -> String{
        var value = ""
        switch label {
        case "Positive":
           
            var buffer:[String] = []
            var counts: [String: Int] = [:]
            
            for element in PosActivitesList{
                if element == PosActivitesList.first{
                    buffer = element
                }else{
                    buffer += element
                    //print("Buffer in loop POS: \(buffer)")
                    }
                }
            buffer.forEach { counts[$0, default: 0] += 1 }

            //print("count: \(counts)")
            
           let sortedByValueDictionary = counts.sorted { $0.1 < $1.1 }
           self.PosSortedActDict = Array(sortedByValueDictionary)
          
            //print("PosSortedActDict: \(PosSortedActDict)")
            if counts.count >= 3 {
                  buffer.removeAll()
            for i in 0...2 {
                buffer.append(Array(self.PosSortedActDict)[i].key)
            }
            }
         
           // print("Buffer after sorted: \(buffer)")
            
            //print("Output of pos:  \(buffer)")
            //print("Pos List:  \(PosActivitesList)")
            value = translate(buffer: buffer)
            return value
            
        case "Negative":
            
            var buffer:[String] = []
             var counts: [String: Int] = [:]
            for  element in NegActivitesList {
                if element == NegActivitesList.first{
                    buffer = element
                }else{
                buffer += element
                             //print("Buffer in loop NEG: \(buffer)")
                             }
                         }
                     buffer.forEach { counts[$0, default: 0] += 1 }

                     //print("count: \(counts)")
                     
                     let sortedByValueDictionary = counts.sorted { $0.1 < $1.1 }
                    self.NegSortedActDict = Array(sortedByValueDictionary)
                     //print("NegSortedActDict: \(NegSortedActDict)")
                     if counts.count >= 3 {
                         buffer.removeAll()
                     for i in 0...2 {
                         buffer.append(Array(sortedByValueDictionary)[i].key)
                     }
                     }
            //print("Output of Neg:  \(buffer)")
            value = translate(buffer: buffer)
            loadNeuDict()

            return value
            

        default:
            print("Can not return comment factor")
            return ""
         
        }
    }
    
    func loadNeuDict(){
        var buffer:[String] = []
         var counts: [String: Int] = [:]
        for  element in NeuActivitesList {
            if element == NeuActivitesList.first{
                buffer = element
            }else{
            buffer += element
                         //print("Buffer in loop NEG: \(buffer)")
                         }
                     }
                 buffer.forEach { counts[$0, default: 0] += 1 }

                 //print("count: \(counts)")
                 
                 let sortedByValueDictionary = counts.sorted { $0.1 < $1.1 }
                self.NeuSortedActDict = Array(sortedByValueDictionary)
                //print("NeuSortedActDict: \(NeuSortedActDict)")
        //print("Output of Neu:  \(buffer)")
    }
    
    func translate(buffer: [String])->String{
        var BufferString = ""
        for element in buffer{
            if element == buffer.first{
                 BufferString += "\(element)"
            }else if element == buffer.last{
                BufferString += "\(element)."
            }else{
                BufferString += ",\(element),"}
        }
        if BufferString == ""{
            BufferString = "無相關記錄！"
        }
        return BufferString
    }
    
    func reload(){
        self.PosActivitesList = []
        self.NegActivitesList = []
        self.NeuActivitesList = []
    }
func Record(label: String) -> [(String,Int)]{
        switch label {
        case "Positive":
            return self.PosSortedActDict
        case "Negative":
            return self.NegSortedActDict
        case "Neutral":
             return self.NeuSortedActDict
        default:
            return [("", 0)]
        }
    }
    func RecordCount(label: String) -> Int {
    switch label {
    case "Positive":
        return self.PosSortedActDict.count
    case "Negative":
        return self.NegSortedActDict.count
    case "Neutral":
        return self.NeuSortedActDict.count
    default:
        return 0
    }
    }
}

class Dates{
  
    var RecordType = ""
    var label = ""
    var imageURLString = ""
    var ImageURL:URL = URL(string: "https://www.apple.com")!
    var Activites:[String] = []
    var Date: Int
    var text: String
    var textLabel: String
    
    init(Date:Int,RecordType:String, label :String,imageURLString :String,AlertActivites :[String],Text: String , TextLabel: String) {
        self.RecordType = RecordType
        self.label = label
        self.Date = Date
        //print("Date of Date object: \(self.Date)")
        self.imageURLString = imageURLString
        if RecordType == "Image" {
            self.ImageURL = NSURL(string: imageURLString)! as URL
        }
        self.Activites = AlertActivites
        self.text = Text
        self.textLabel = TextLabel
        
    }
}


class DataSetValueFormatter: IValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        ""
    }
}



class YAxisFormatter: IAxisValueFormatter {
    //var buffer = -1
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        //print("Vlaue of y-axis: \(Int(value))")
        //buffer += 1
        return "\(Int(value))"
    }
}
