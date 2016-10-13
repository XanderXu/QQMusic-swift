//
//  QQMusicModel.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/4.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    //歌曲名
    var name : String?
    //歌曲的文件名
    var filename : String?
    //歌词文件名
    var lrcname : String?
    //歌手
    var singer : String?
    //歌手头像
    var singerIcon : String?
    //专辑图片
    var icon : String?
    override init() {
        super.init()
    }
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
