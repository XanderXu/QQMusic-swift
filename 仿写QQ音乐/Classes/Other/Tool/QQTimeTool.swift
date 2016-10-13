//
//  QQTimeTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//  时间格式处理

import UIKit

class QQTimeTool: NSObject {
    class func getFormatTime(_ timeNum : TimeInterval) -> String {
        let min = Int(timeNum / 60)
        let sec = Int(timeNum.truncatingRemainder(dividingBy: 60))
        let resultStr = String(format: "%02d:%02d", min, sec)
        return resultStr
    }
    class func getTimeInterva(_ timeStr : String) -> TimeInterval {
        let minAndSec = timeStr.components(separatedBy: ":")
        if minAndSec.count == 2 {
            let min = TimeInterval(minAndSec[0]) ?? 0
            let sec = TimeInterval(minAndSec[1]) ?? 0
            return min * 60 + sec
        }
        return 0
    }
}
