//
//  BusinessTableViewCell.swift
//  ios8_yelp
//
//  Created by Stanley Ng on 9/20/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var photoBoxImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    var index: Int = 0
    var business: Business! = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() {
        if business == nil {
            return
        }
        
        /*
        // Photo Box
        [cell.photoBoxImageView.layer setMasksToBounds:YES];
        [cell.photoBoxImageView.layer setCornerRadius:10.0f];
        [cell.photoBoxImageView setAlpha:0.0f];
        [cell.photoBoxImageView setImageWithURL:[NSURL URLWithString:business[@"image_url"]]
        placeholderImage:[UIImage imageNamed:@"photo-box-placeholder"]
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        // Fade in image
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:1.0];
        [cell.photoBoxImageView setAlpha:1.0f];
        [UIView commitAnimations];
        }
        usingActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        */
        
        // Photo Box
        photoBoxImageView.layer.masksToBounds = true
        photoBoxImageView.layer.cornerRadius = 10
        photoBoxImageView.alpha = 0
        photoBoxImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: business.imageUrl)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            
            self.photoBoxImageView.image = image
            UIView.beginAnimations("fade in", context: nil)
            UIView.setAnimationDuration(0.4)
            self.photoBoxImageView.alpha = 1
            UIView.commitAnimations()
            
        }, failure: nil)
        
        // Name
        nameLabel.numberOfLines = 0
        nameLabel.text = "\(index + 1). \(business.name)"
        nameLabel.sizeToFit()
        
        // Rating Image
        ratingImageView.setImageWithURL(NSURL(string: business.ratingImageUrl))
        
        // Review Count
        reviewCountLabel.text = "\(business.reviewCount) Reviews"
        
        // Address
        var addressList = business.location["address"] as NSArray
        if let neighborhoods = business.location["neighborhoods"] as? NSArray {
            addressList = addressList.arrayByAddingObjectsFromArray(neighborhoods)
        }
        addressLabel.numberOfLines = 0
        addressLabel.text = addressList.componentsJoinedByString(", ")
        addressLabel.sizeToFit()
        
        // Categories
        var categoryList = NSMutableArray()
        for category in (business.categories as NSArray) {
            categoryList.addObject(category[0])
        }
        categoriesLabel.numberOfLines = 0
        categoriesLabel.text = categoryList.componentsJoinedByString(", ")
        categoriesLabel.sizeToFit()
    }
    
}
