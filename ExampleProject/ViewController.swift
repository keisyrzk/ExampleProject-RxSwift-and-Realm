//
//  ViewController.swift
//  ExampleProject
//
//  Created by keisyrzk on 15.03.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ViewController: UIViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: Table!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!

    var shownCities = [CityModel]()     // Data source for UITableView while searching
    var cities: [CityModel] = []        // fetched data
    let disposeBag = DisposeBag()       // Bag of disposables to release them when view is being deallocate
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "tableCell")
        cities = DataManager().read()
        table.inputDataSource = cities
        table.reloadData()
        
        searchBarRxSetup()
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func searchBarRxSetup()
    {
        searchBar.delegate = self
        searchBar
            .rx.text    // Observable property thanks to RxCocoa
            .orEmpty    // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance)   // Wait 0.5 for changes.
            .distinctUntilChanged()     // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty }     // If the new value is really new, filter for non-empty query
                // Here we will be notified of every new value
            .subscribe(onNext: { [unowned self] query in

                    //filter the data according to segmented controll - by city, country or continent
                switch self.segmentCtrl.selectedSegmentIndex
                {
                case 0:
                    self.shownCities = self.cities.filter { $0.cityName.hasPrefix(query) }
                case 1:
                    self.shownCities = self.cities.filter { $0.cityCategory.country.hasPrefix(query) }
                case 2:
                    self.shownCities = self.cities.filter { $0.cityCategory.continent.hasPrefix(query) }
                    
                default:
                    print("")
                }

                self.table.inputDataSource = self.shownCities
                self.table.reloadData() // And reload table view data.
            })
            .addDisposableTo(disposeBag)

        
        
//  server fetch data with rx search bar example
//        searchBar.rx.text
//            .throttle(1, scheduler: MainScheduler.instance)
//            .debounce(1, scheduler: MainScheduler.asyncInstance)
//            .subscribe(onNext: { (next) in
//                if let _text = next
//                {
//                    self.getUsersFromServer(searchString: _text)
//                }
//            }, onError: { error in
//                print("Error: \(error.localizedDescription)")
//            }, onCompleted: {
//                print("Completed")
//            }, onDisposed: {
//                print("disponse")
//            }).addDisposableTo(disponseBag)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == ""
        {
            self.table.inputDataSource = self.cities
            self.table.reloadData()
            
            searchBar.resignFirstResponder()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    @IBAction func addAction(_ sender: Any)
    {
        let alert = UIAlertController(title: "ADD", message: nil, preferredStyle: .alert)
        alert.addTextField { (cityTF) in
            cityTF.autocapitalizationType = .words
            cityTF.placeholder = "City"
        }
        alert.addTextField { (countryTF) in
            countryTF.autocapitalizationType = .words
            countryTF.placeholder = "Country"
        }
        alert.addTextField { (continentTF) in
            continentTF.autocapitalizationType = .words
            continentTF.placeholder = "Continent"
        }
        
        let add = UIAlertAction(title: "ADD", style: .default) { (_) in
            
            let newCity = CityModel()           //new CityModel object
            let newCategory = CityCategory()    //new CityCategory object
            
                //assign entered values to the right properties
            newCity.cityName = (alert.textFields?[0].text!)!
            newCategory.country = (alert.textFields?[1].text!)!
            newCategory.continent = (alert.textFields?[2].text!)!
            newCity.cityCategory = newCategory
            
                //write the new CityModel (with its new CityCategory object) into realm database
            DataManager().write(cityObject: newCity)
            
                //read all data from realm database and reeload the table
            self.cities = DataManager().read()
            self.table.inputDataSource = self.cities
            self.table.reloadData()
        }
        
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    


}//end of class

