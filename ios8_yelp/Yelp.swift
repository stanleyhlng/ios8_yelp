//
//  Yelp.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import Foundation

class Option {
    var name = ""
    var value = ""
    var isSelected: Bool?
    
    init(name: String, value: String, isSelected: Bool? = false) {
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
}

class Filter {
    var name = ""
    var options = Array<Option>()
    var selectedIndex: Int?
    
    init(name: String, options: [Option], selectedIndex: Int? = 0) {
        self.name = name
        self.options = options
        self.selectedIndex = selectedIndex
    }
}

class Yelp {
    
    var filters =
    [
        Filter(name: "Most Popular", options:
            [
                Option(name: "Offering a Deal", value: "", isSelected: false)
            ]
        ),
        Filter(name: "Distance", options:
            [
                Option(name: "Auto",        value: "40000"),
                Option(name: "0.3 miles",   value: "482.803"),
                Option(name: "1 mile",      value: "1609.34"),
                Option(name: "5 miles",     value: "8046.72"),
                Option(name: "20 miles",    value: "32186.9")
            ],
            selectedIndex: 0
        ),
        Filter(name: "Sort by", options:
            [
                Option(name: "Best Match",  value: "0"),
                Option(name: "Distance",    value: "1"),
                Option(name: "Rating",      value: "2")
            ],
            selectedIndex: 0
        ),
        Filter(name: "Categories", options:
            [
                Option(name: "American (New)",          value: "newamerican",       isSelected: false),
                Option(name: "American (Traditional)",  value: "tradamerican",      isSelected: false),
                Option(name: "Argentine",               value: "argentine",         isSelected: false),
                Option(name: "Asian Fusion",            value: "asianfusion",       isSelected: false),
                Option(name: "Australian",              value: "australian",        isSelected: false),
                Option(name: "Austrian",                value: "austrian",          isSelected: false),
                Option(name: "Beer Garden",             value: "beergarden",        isSelected: false),
                Option(name: "Belgian",                 value: "belgian",           isSelected: false),
                Option(name: "Brazilian",               value: "brazilian",         isSelected: false),
                Option(name: "Breakfast & Brunch",      value: "breakfast_brunch",  isSelected: false),
                Option(name: "Buffets",                 value: "buffets",           isSelected: false),
                Option(name: "Burgers",                 value: "burgers",           isSelected: false),
                Option(name: "Burmese",                 value: "burmese",           isSelected: false),
                Option(name: "Cafes",                   value: "cafes",             isSelected: false),
                Option(name: "Cajun/Creole",            value: "cajun",             isSelected: false),
                Option(name: "Canadian",                value: "newcanadian",       isSelected: false),
                Option(name: "Chinese",                 value: "chinese",           isSelected: false),
                Option(name: "Cantonese",               value: "cantonese",         isSelected: false),
                Option(name: "Dim Sum",                 value: "dimsum",            isSelected: false),
                Option(name: "Cuban",                   value: "cuban",             isSelected: false),
                Option(name: "Diners",                  value: "diners",            isSelected: false),
                Option(name: "Dumplings",               value: "dumplings",         isSelected: false),
                Option(name: "Ethiopian",               value: "ethiopian",         isSelected: false),
                Option(name: "Fast Food",               value: "hotdogs",           isSelected: false),
                Option(name: "French",                  value: "french",            isSelected: false),
                Option(name: "German",                  value: "german",            isSelected: false),
                Option(name: "Greek",                   value: "greek",             isSelected: false),
                Option(name: "Indian",                  value: "indpak",            isSelected: false),
                Option(name: "Indonesian",              value: "indonesian",        isSelected: false),
                Option(name: "Irish",                   value: "irish",             isSelected: false),
                Option(name: "Italian",                 value: "italian",           isSelected: false),
                Option(name: "Japanese",                value: "japanese",          isSelected: false),
                Option(name: "Jewish",                  value: "jewish",            isSelected: false),
                Option(name: "Korean",                  value: "korean",            isSelected: false),
                Option(name: "Venezuelan",              value: "venezuelan",        isSelected: false),
                Option(name: "Malaysian",               value: "malaysian",         isSelected: false),
                Option(name: "Pizza",                   value: "pizza",             isSelected: false),
                Option(name: "Russian",                 value: "russian",           isSelected: false),
                Option(name: "Salad",                   value: "salad",             isSelected: false),
                Option(name: "Scandinavian",            value: "scandinavian",      isSelected: false),
                Option(name: "Seafood",                 value: "seafood",           isSelected: false),
                Option(name: "Turkish",                 value: "turkish",           isSelected: false),
                Option(name: "Vegan",                   value: "vegan",             isSelected: false),
                Option(name: "Vegetarian",              value: "vegetarian",        isSelected: false),
                Option(name: "Vietnamese",              value: "vietnamese",        isSelected: false)
            ]
        )
    ]
    
    func getSearchParamsWithTerm(term: String? = "Thai") -> [String: String] {
        var params = Dictionary<String, String>()
        params["term"] = term!
        params["limit"] = "20"
        params["offset"] = "0"
        params["sort"] = filters[2].options[filters[2].selectedIndex!].value
        params["radius_filter"] = filters[1].options[filters[1].selectedIndex!].value
        params["location"] = "San Jose"
        params["cli"] = "37.400428,-121.925681"
        
        if filters[0].options[0].isSelected! {
            params["deals_filter"] = "1"
        } else {
            params["deals_filter"] = "0"
        }
        
        var selectedCategories = Array<String>()
        for option in filters[3].options {
            if option.isSelected! {
                selectedCategories.append(option.value)
            }
        }
        params["category_filter"] = ",".join(selectedCategories)
        return params
    }
    
    class var sharedInstace: Yelp {
        struct Static {
            static let instance: Yelp = Yelp()
        }
        return Static.instance
    }
}