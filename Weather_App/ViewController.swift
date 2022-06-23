//
//  ViewController.swift
//  Weather_App
//
//  Created by Vladimir Alyoshkin on 08.06.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "https://api.weatherapi.com/v1/current.json?key=d559e6ad31b142cfbaa182119221906&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
         let url = URL(string: urlString)
        
        var locationName: String?
        var temperature: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let _ = json["error"] {
                    errorHasOccured = true
                }
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
         }
                
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
        }
                
                DispatchQueue.main.sync {
                    
                    if errorHasOccured {
                        self?.cityLable.text = "Error has occured"
                        self?.temperatureLable.isHidden = true
                        
                    }
                    else {
                    self?.cityLable.text = locationName
                    self?.temperatureLable.text = "\(temperature!)"
                        
                    self?.temperatureLable.isHidden = false
                }
            }
    }
        catch let jsonError {
        print(jsonError)
        
    }
        }
        
        task.resume()
        
    }
}
