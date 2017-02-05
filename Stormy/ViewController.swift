//
//  ViewController.swift
//  Stormy
//
//  Created by David Jansson Hultgren on 2015-05-24.
//  Copyright (c) 2015 davloop. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var precipitationLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var refrshButton: UIButton!
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    
    private let apiKey = "4cb6c8fa001be9116c4523af12d962c4"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshActivityIndicator.hidden = true
        getCurrenWeatherData()
       
        
    }
    
    func getCurrenWeatherData() -> Void{
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        // Location added here
        let forecastURL = NSURL(string: "59.326142,17.9875454", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL?, response: NSURLResponse?, error:NSError?) -> Void in
            
            if (error == nil ) {
                let dataObject = NSData(contentsOfURL: location!)
                let weatherDictionary: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    
                    
                    // stop button refresh
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refrshButton.hidden = false
                    
                    
                })
                
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
            
                
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // stop button refresh
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refrshButton.hidden = false
                })
                
                
                
            }
                
                
                
            
        })
        
        downloadTask.resume()

        
    }
    
    
    

    @IBAction func refresh() {
        
        getCurrenWeatherData()
        
        refrshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }
  
    
        
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

