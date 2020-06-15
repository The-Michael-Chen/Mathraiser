//
//  CharityCellTableViewCell.swift
//  Mathraiser
//
//  Created by Michael Chen on 6/14/20.
//  Copyright © 2020 ChenOutOfTen. All rights reserved.
//

import UIKit
import Firebase

class CharityCell: UITableViewCell {
    
    var charity: Charity {
        didSet {
            detailTextLabel?.text = charity.Description
            textLabel?.text = charity.Name
            textLabel?.font = UIFont.systemFont(ofSize: 15)
            textLabel?.lineBreakMode = .byTruncatingTail
            detailTextLabel?.numberOfLines = 3
            detailTextLabel?.lineBreakMode = .byTruncatingTail
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2 , width: 220, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y  , width: 320, height: detailTextLabel!.frame.height)
    }
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
