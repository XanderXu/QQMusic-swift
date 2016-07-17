//
//  QQLrcDataTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQLrcDataTool: NSObject {
    //根据歌词数组和当前播放进度,得到行号和当前这一句歌词
    class func getRowAndLrcM(costTime : NSTimeInterval, lrcModels : [QQLrcModel]) ->(row : Int, lrcM : QQLrcModel) {
        let count = lrcModels.count
        //根据时间判断是哪一句歌词
        for i in 0..<count {
            let lrcModel = lrcModels[i]
            if costTime > lrcModel.beginTime && costTime < lrcModel.endTime {
                return (i, lrcModel)
            }
        }
        //否则返回0和空模型
        return (0, QQLrcModel())
    }
    
    //根据lrc歌词文件的路径,得到歌词模型
    class func getLrcModels(lrcName : String?) -> [QQLrcModel] {
        //读取歌词文件路径
        guard let path = NSBundle.mainBundle().pathForResource(lrcName, ofType: nil) else {
            return [QQLrcModel]() //不成功返回空的模型数组
        }
        var lrc = ""
        do {
            lrc = try String(contentsOfFile: path)
        }catch {
            print(error)//打印错误,error是隐藏参数
            return [QQLrcModel]()//不成功返回空的模型数组
        }
        //将歌词字符串转换为数组
        let lrcArray = lrc.componentsSeparatedByString("\n")
        var lrcModels = [QQLrcModel]()
        for lrcStr in lrcArray {
            //处理开头的额外数据
            if lrcStr.containsString("[ti:") || lrcStr.containsString("[ar:") || lrcStr.containsString("[al:") {
                continue
            }
            //创建模型,将单句歌词添加到数组
            let lrcModel = QQLrcModel()
            lrcModels.append(lrcModel)
            //将每一句的时间和歌词分开
            let tempStr = lrcStr.stringByReplacingOccurrencesOfString("[", withString: "")
            let timeAndLrc = tempStr.componentsSeparatedByString("]")
            if timeAndLrc.count == 2 {
                let timeStr = timeAndLrc[0]
                //起始时间
                lrcModel.beginTime = QQTimeTool.getTimeInterva(timeStr)
                let lrcStr = timeAndLrc[1]
                lrcModel.lrcStr = lrcStr
            }
        }
        //拿到下一句的起始时间,作为上一句的结束时间
        let count = lrcModels.count
        for i in 0..<count {
            if i != count - 1 {
                lrcModels[i].endTime = lrcModels[i + 1].beginTime
            } else {
                lrcModels[i].endTime = lrcModels[i].beginTime
            }
        }
        return lrcModels
    }
}
