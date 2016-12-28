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
    
    ///셀의 높이를 계산해서 반환합니다.
    ///
    /// - parameter width :  셀의 너비
    /// - parameter title : "점심" 또는 "저녁"
    /// - parameter content : 식단 텍스트
    /// - returns : 실제 셀 높이를 반환합니다
    class func height(width : CGFloat, title : String, content : String) -> CGFloat{
        let titleWidth = self.size(
            for: title,
            width: 0,
            font: UIFont.systemFont(ofSize: 15)
        ).width
        let contentWidth = width - titleWidth - 10 - 10 - 10
        let contentHeight = self.size(
            for : content,
            width : contentWidth,
            font : UIFont.systemFont(ofSize: 15)
        ).height
        
        return 10 + contentHeight + 10
    }
    
    class func size(for string : String, width : CGFloat, font : UIFont) -> CGSize {
        let rect = string.boundingRect(
            with: CGSize(width : width, height : 0),
            options: [.usesFontLeading, .usesLineFragmentOrigin],
            attributes: [NSFontAttributeName : font],
            context: nil
        )
        
        return rect.size
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
