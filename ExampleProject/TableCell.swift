//
//  TableCell.swift
//  ExampleProject
//
//  Created by keisyrzk on 15.03.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell
{
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellCountry: UILabel!
    @IBOutlet weak var cellContinent: UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(cityModel: CityModel)
    {
        cellTitle.text = cityModel.cityName
        cellCountry.text = cityModel.cityCategory.country
        cellContinent.text = cityModel.cityCategory.continent
    }
    
    override func prepareForReuse()
    {
        cellTitle.text = ""
        cellCountry.text = ""
        cellContinent.text = ""
    }
    
    
}
