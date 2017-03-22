//
//  CityModel.swift
//  ExampleProject
//
//  Created by keisyrzk on 22.03.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import Foundation
import RealmSwift

class CityModel: Object
{
    dynamic var cityName = ""
    dynamic var cityCategory: CityCategory!
}
