//
//  QQImageTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQImageTool: NSObject {
    class func getNewImage(sourceImage : UIImage, str : String) ->UIImage {
        //开启上下文
        let size = sourceImage.size;
        UIGraphicsBeginImageContext(size)
        //绘制原图
        sourceImage.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //段落样式
        let style = NSMutableParagraphStyle()
        style.alignment = .Center
        let dict : [String : AnyObject] = [NSForegroundColorAttributeName : UIColor.whiteColor(),NSFontAttributeName : UIFont.systemFontOfSize(20), NSParagraphStyleAttributeName : style]
        //绘制文字(先转换格式)
        (str as NSString).drawInRect(CGRect(x: 0, y: 5, width: size.width, height: 25), withAttributes: dict)
        //取出图文
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        return resultImage
    }
}
