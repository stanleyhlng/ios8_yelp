//
//  SearchViewController.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("SearchViewController.viewDidLoad")
        customizeNavBarTitleView()
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeNavBarTitleView() {
        searchBar = UISearchBar()
        searchBar?.delegate = self
        searchBar?.searchBarStyle = UISearchBarStyle.Minimal

        navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        cell.textLabel?.text = "search"
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("SearchViewController.didSelectRowAtIndexPath: \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("SearchViewController.searchBarSearchButtonClicked")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
