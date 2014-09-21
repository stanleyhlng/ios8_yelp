//
//  SearchViewController.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar!
    var client: YelpClient!

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("SearchViewController.viewDidLoad")
        customizeNavBarTitleView()
        setupTableView()
        //doFetch(["term": "Thai"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeNavBarTitleView() {
        searchBar = UISearchBar()
        searchBar?.delegate = self
        searchBar?.searchBarStyle = UISearchBarStyle.Minimal
        searchBar?.placeholder = ""

        navigationItem.titleView = searchBar
    }
    
    func doFetch(term: String) {
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        let params = Yelp.sharedInstace.getSearchParamsWithTerm(term: term)
        
        client.searchWithParams(params,
            success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    println(response)
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println(error)
            }
        )
        
//        client.searchWithTerm("Thai",
//            success: {
//                (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                println(response)
//            },
//            failure: {
//                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println(error)
//            }
//        )
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - FiltersViewControllerDelegate
    
    func searchWithFilters(message: String) {
        println("SearchViewController.searchWithFilters")
        doFetch(searchBar.text)
    }
    
    // MARK: - UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        cell.textLabel?.text = "search"
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    // MARK: - UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("SearchViewController.didSelectRowAtIndexPath: \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("SearchViewController.searchBarSearchButtonClicked")
        
        searchBar.resignFirstResponder()
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.destinationViewController is UINavigationController {
        
            var nav = segue.destinationViewController as UINavigationController
            
            if nav.viewControllers[0] is FiltersViewController {
                var controller = nav.viewControllers[0] as FiltersViewController
                controller.delegate = self
            }
        }
        
    }

}
