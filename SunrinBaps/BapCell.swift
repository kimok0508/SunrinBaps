//
//  BapCell.swift
//  SunrinBaps
//
//  Created by MacBookPro on 2016. 12. 26..
//  Copyright © 2016년 EDCAN. All rights reserved.
//

import UIKit

class BapCell : UITableViewCell{
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.contentLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentLabel.numberOfLines = 0
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame.origin.x = 10
        self.titleLabel.frame.origin.y = 10
        self.titleLabel.sizeToFit()
        
        self.contentLabel.frame.origin.x = titleLabel.frame.maxX + 10
        self.contentLabel.frame.origin.y = 10
        self.contentLabel.frame.size.width =
            self.contentView.frame.size.width - self.titleLabel.frame.maxX - 10 - 10
        self.contentLabel.sizeToFit()
    }
}
