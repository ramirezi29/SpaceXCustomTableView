//
//  LaunchTableViewController.swift
//  SpaceXInClass_iOS22
//
//  Created by Ivan Ramirez on 10/23/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class LaunchTableViewController: UITableViewController {

    // MARK: - Fuente De Verdad
    var launches: [Launch] = []
    
    @IBOutlet weak var launchSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchSearchBar.delegate = self
        launchSearchBar.placeholder = "Enter Data from 2006 - 2018"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return launches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as? LaunchTableViewCell else {return UITableViewCell()}

        let launch = launches[indexPath.row]
        cell.launch = launch

        // NOTE: -  Make the call for the image
        LaunchController.fetchImage(for: launch) { (patchImage) in
            if let patchImage = patchImage {
                cell.patchImage = patchImage
            }
        }
        return cell
    }
   
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 0, alpha: 0)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}



extension LaunchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let launchYearSearchText = searchBar.text, !launchYearSearchText.isEmpty else {return}
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        LaunchController.fetchLaunches(launchYear: launchYearSearchText) { (launches) in
            guard let launches = launches else {return}
            
            // NOTE: - This allows the launches to be become part of our Source of Truth
            self.launches = launches
            
            DispatchQueue.main.async {
              
                self.tableView.reloadData()
            }
        }
    }
}
