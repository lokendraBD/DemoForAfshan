//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Lokendra Kapoor on 10/10/18.
//  Copyright © 2018 Bionic Dragons. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewForWeatherData: UITableView!
    @IBOutlet weak var segmentedControlForDates: UISegmentedControl!
    var stringForURL = "https://samples.openweathermap.org/data/2.5/forecast?id=524901&appid=b6907d289e10d714a6e88b30761fae22"
    
    var arrayForHeaders = ["Temperature",
                           "Min. Temperature",
                           "Max. Temperature",
                           "Pressure",
                           "Sea level",
                           "Groud level",
                           "Humidity",
                           "Temp_KF",
                          ]
    var arrayForSubTexts:[String] = []
//    var weatherData = [String: Any]()
    var weatherData = Dictionary<String, Any>()
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Moscow Weather"
        self.tableViewForWeatherData.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        let date1 = Date()
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let date3 = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        let date4 = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        let date5 = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let string1ForDate = dateFormatter.string(from: date1)
        let string2ForDate = dateFormatter.string(from: date2)
        let string3ForDate = dateFormatter.string(from: date3)
        let string4ForDate = dateFormatter.string(from: date4)
        let string5ForDate = dateFormatter.string(from: date5)
        
        self.segmentedControlForDates.setTitle(string1ForDate, forSegmentAt: 0)
        self.segmentedControlForDates.setTitle(string2ForDate, forSegmentAt: 1)
        self.segmentedControlForDates.setTitle(string3ForDate, forSegmentAt: 2)
        self.segmentedControlForDates.setTitle(string4ForDate, forSegmentAt: 3)
        self.segmentedControlForDates.setTitle(string5ForDate, forSegmentAt: 4)
        
        self.getResponseFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionForSegmentedControlChangeInIndex(_ sender: Any) {
        let index = self.segmentedControlForDates.selectedSegmentIndex
        print(index)
        self.printResponseForFirstDate(index: index)
    }
    
    func getResponseFromServer() {
        Alamofire.request(self.stringForURL).responseJSON { response in

            if let json = response.result.value {
                self.weatherData = json as! Dictionary
                print(self.weatherData)
                self.printResponseForFirstDate(index: 0)
            }
        }
    }
    
    func printResponseForFirstDate(index:Int) {
        var arr:Array<Any> = self.weatherData["list"] as! Array
        
        var obj:Dictionary<String, Any> = arr[8*index] as! Dictionary
        var obj2:Dictionary<String, Any> = obj["main"] as! Dictionary
        let temp = obj2["temp"] as! NSNumber
        let temp_min = obj2["temp_min"] as! NSNumber
        let temp_max = obj2["temp_max"] as! NSNumber
        let pressure = obj2["pressure"] as! NSNumber
        let sea_level = obj2["sea_level"] as! NSNumber
        let grnd_level = obj2["grnd_level"] as! NSNumber
        let humidity = obj2["humidity"] as! NSNumber
        let temp_kf = obj2["temp_kf"] as! NSNumber

        self.arrayForSubTexts = []
        self.arrayForSubTexts.append(temp.stringValue)
        self.arrayForSubTexts.append(temp_min.stringValue)
        self.arrayForSubTexts.append(temp_max.stringValue)
        self.arrayForSubTexts.append(pressure.stringValue)
        self.arrayForSubTexts.append(sea_level.stringValue)
        self.arrayForSubTexts.append(grnd_level.stringValue)
        self.arrayForSubTexts.append(humidity.stringValue)
        self.arrayForSubTexts.append(temp_kf.stringValue)
        self.tableViewForWeatherData.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayForSubTexts.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
//        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
                               reuseIdentifier: cellReuseIdentifier)

        // set the text from the data model
        cell.textLabel?.text = self.arrayForHeaders[indexPath.row]
        cell.detailTextLabel?.text = self.arrayForSubTexts[indexPath.row]

        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

