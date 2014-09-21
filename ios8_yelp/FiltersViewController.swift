//
//  FiltersViewController.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func searchWithFilters(message: String)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var delegate: FiltersViewControllerDelegate?
    var collapsedSectionIndex =
        [
            "Most Popular": false,
            "Distance": true,
            "Sort by": true,
            "Categories": true
        ]
    var collapsedCountForCategories = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("FiltersViewController.viewDidLoad")
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func handleCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }

    func handleFilterForMostPopular(sender: AnyObject!) -> Void {
        var switchView = sender as UISwitch
        println("handle most popular, tag \(switchView.tag)")
        
        let filter = Yelp.sharedInstace.filters[0]
        var option = filter.options[switchView.tag]
        println("option.isSelected: \(option.isSelected)")
        option.isSelected! = !option.isSelected!
    }
    
    func handleFilterForCategories(sender: AnyObject!) -> Void {
        var switchView = sender as UISwitch
        println("handle categories, tag \(switchView.tag)")
        
        let filter = Yelp.sharedInstace.filters[3]
        var option = filter.options[switchView.tag]
        option.isSelected! = !option.isSelected!
    }
    
    @IBAction func handleSearchButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            println("FiltersViewController.done")
    
            self.delegate?.searchWithFilters("")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Yelp.sharedInstace.filters.count
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var filter = Yelp.sharedInstace.filters[section] as Filter
        if (collapsedSectionIndex[filter.name]!) {
            if filter.name == "Categories" {
                return collapsedCountForCategories + 1
            }
            else {
                return 1
            }
        }
        else {
            return filter.options.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println("section: \(indexPath.section), row: \(indexPath.row)")

        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        
        var filter = Yelp.sharedInstace.filters[indexPath.section] as Filter
        var option = filter.options[indexPath.row]
        
        if filter.name == "Most Popular" {
            // MOST_POPULAR
            
            cell.textLabel!.text = option.name
            
            var switchView = UISwitch(frame: CGRectZero)
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryView = switchView
            switchView.tintColor = UIColor(hexString: "#BA0C03")
            switchView.onTintColor = UIColor(hexString: "#BA0C03")
            switchView.tag = indexPath.row
            switchView.on = option.isSelected!
            switchView.addTarget(self, action: "handleFilterForMostPopular:", forControlEvents: UIControlEvents.ValueChanged)
        }
        else if filter.name == "Distance" {
            // DISTANCE
            
            var idx = filter.selectedIndex
            
            if collapsedSectionIndex[filter.name]! {
                cell.textLabel!.text = (filter.options[idx!] as Option).name
            }
            else {
                if idx == indexPath.row {
                    cell.backgroundColor = UIColor(hexString: "#BA0C03")
                    cell.textLabel!.textColor = UIColor.whiteColor()
                }
                cell.textLabel!.text = option.name
            }
        }
        else if filter.name == "Sort by" {
            // SORT_BY
            
            var idx = filter.selectedIndex
            
            if collapsedSectionIndex[filter.name]! {
                cell.textLabel!.text = (filter.options[idx!] as Option).name
            }
            else {
                if idx == indexPath.row {
                    cell.backgroundColor = UIColor(hexString: "#BA0C03")
                    cell.textLabel!.textColor = UIColor.whiteColor()
                }
                cell.textLabel!.text = option.name
            }
        }
        else if filter.name == "Categories" {
            // CATEGORIES
            
            if indexPath.row == self.collapsedCountForCategories && self.collapsedSectionIndex[filter.name]! {
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.textLabel?.textColor = UIColor(hexString: "#808080")
                cell.textLabel?.text = "See All"
            }
            else {
                cell.textLabel?.text = option.name

                var switchView = UISwitch(frame: CGRectZero)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryView = switchView
                switchView.tintColor = UIColor(hexString: "#BA0C03")
                switchView.onTintColor = UIColor(hexString: "#BA0C03")
                switchView.tag = indexPath.row
                switchView.on = option.isSelected!
                switchView.addTarget(self, action: "handleFilterForCategories:", forControlEvents: UIControlEvents.ValueChanged)
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Yelp.sharedInstace.filters[section].name
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println("did select row at index path: section \(indexPath.section), row \(indexPath.row)")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var filter = Yelp.sharedInstace.filters[indexPath.section]
        var indexSet = NSMutableIndexSet(index: indexPath.section)
        
        if filter.name == "Most Popular" {
            // MOST_POPULAR

        }
        else if filter.name == "Distance" {
            // DISTANCE
            
            if !collapsedSectionIndex[filter.name]! {
                // update data
                filter.selectedIndex = indexPath.row
                println("selected index: \(filter.selectedIndex)")
            }

            collapsedSectionIndex[filter.name]! = !collapsedSectionIndex[filter.name]!
            tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        else if filter.name == "Sort by" {
            // SORT_BY
            
            if !collapsedSectionIndex[filter.name]! {
                // update data
                filter.selectedIndex = indexPath.row
                println("selected index: \(filter.selectedIndex)")
            }
            collapsedSectionIndex[filter.name]! = !collapsedSectionIndex[filter.name]!
            tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
        else if filter.name == "Categories" {
            // CATEGORIES
            
            if indexPath.row == collapsedCountForCategories {
                collapsedSectionIndex[filter.name] = false
                tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            
        }
    }
    
}
