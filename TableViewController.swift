//
//  TableView.swift
//  Places
//
//  Created by Federico Naranjo Bellina on 20/3/18.
//  Copyright © 2018 Federico Naranjo Bellina. All rights reserved.
//

import UIKit

var addresses:[String] = [String]()
var longitudes:[Double] = [Double]()
var latitudes:[Double] = [Double]()

class TableViewController: UITableViewController {
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBAction func clearPlaces(_ sender: Any) {
        print("clear places")
        addresses.removeAll()
        longitudes.removeAll()
        latitudes.removeAll()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    /// Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    /// Populates rows with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "place", for: indexPath)
        let address = addresses[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = address
        
        return cell
    }
    
    
}


