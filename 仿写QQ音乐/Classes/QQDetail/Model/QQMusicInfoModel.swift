//
//  QQMusicInfoModel.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//  歌曲详细信息

import UIKit

class QQMusicInfoModel: NSObject {
    //音乐模型
    var musicM : QQMusicModel?
    var costTime : TimeInterval = 0
    var totalTime : TimeInterval = 0
    var costTimeFormat : String {
        get {
            return QQTimeTool.getFormatTime(costTime)
        }
    }
    var totalTimeFormat : String {
        get {
            return QQTimeTool.getFormatTime(totalTime)
        }
    }
    var isPlaying : Bool = false
}
