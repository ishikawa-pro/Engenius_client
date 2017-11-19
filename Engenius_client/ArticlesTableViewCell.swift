//
//  ArticlesTableViewCell.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/27.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            //titleLabelのサイズを調整
            if titleLabel != nil {
                titleLabel.sizeToFit()
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
