//
//  ArticlesTableViewCell.swift
//  Engenius_client
//
//  Created by 石川諒 on 2017/03/27.
//  Copyright © 2017年 石川諒. All rights reserved.
//

import UIKit
import AlamofireImage

class ArticlesTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //titleLabelを複数行表示にする
        self.titleLabel.numberOfLines = 0        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //セルにデータを代入する
    func setCell(titleText: String, imageURL: String) -> Void {
        self.titleLabel.text = titleText as String
        //AlamofireImageで非同期で画像を取得して表示する
        self.thumbnailImageView!.af_setImage(withURL: URL(string: imageURL)!)
        //titleLabelのサイズを調整
        self.titleLabel.sizeToFit()
    }
    
    
}
