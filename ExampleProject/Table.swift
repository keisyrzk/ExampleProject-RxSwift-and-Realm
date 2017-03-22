//
//  Table.swift
//  ExampleProject
//
//  Created by keisyrzk on 15.03.2017.
//  Copyright © 2017 keisyrzk. All rights reserved.
//

import UIKit

class Table: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var inputDataSource: [CityModel] = []       //table view datadource
    

    override func awakeFromNib()
    {
        delegate = self
        dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return inputDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableCell
        cell.setup(cityModel: inputDataSource[indexPath.row])

        return cell
    }

}
