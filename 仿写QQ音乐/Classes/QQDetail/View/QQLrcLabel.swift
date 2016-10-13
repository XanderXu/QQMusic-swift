//
//  QQLrcLabel.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {
    //进度更新时刷新
    var progress : Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.green.set()
        let progressFloat = CGFloat(progress)
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * progressFloat, height: rect.size.height)
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
        
    }
}
