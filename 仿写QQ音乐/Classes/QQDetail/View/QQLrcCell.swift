//
//  QQLrcCell.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    @IBOutlet weak var lrcLabel: QQLrcLabel!
    var progress : Double = 0.0 {
        didSet {
            lrcLabel.progress = progress
        }
    }
    var lrcStr : String = "" {
        didSet {
            lrcLabel.text = lrcStr
        }
    }
    class func cellWithTableView(tableView : UITableView) -> QQLrcCell {
        let ID = "lrcCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? QQLrcCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("QQLrcCell", owner: nil, options: nil).first as? QQLrcCell
        }
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
