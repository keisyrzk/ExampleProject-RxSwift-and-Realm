//
//  DataManager.swift
//  ExampleProject
//
//  Created by keisyrzk on 22.03.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager
{
    // NOTE
    // instead of do { try } { catch }
    // Realm can be used as so:
    // let realm = try! Realm()
    
    
    func write(cityObject: CityModel)
    {
        do
        {
            let realm = try Realm()
            
            do
            {
                try realm.write {
                    realm.add(cityObject)
                }
            }
            catch
            {
                print("realm write error")
            }
        }
        catch
        {
            print("realm optional error")
        }
    }
    
    func read() -> [CityModel]
    {
        do
        {
            let realm = try Realm()
            let cities = realm.objects(CityModel.self)
            return Array(cities)
        }
        catch
        {
            print("realm read error")
            return []
        }
    }
}
