//
//  QQMusicDataTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/4.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQMusicDataTool: NSObject {
    class func getMusicList(resultBlock : (musicModels : [QQMusicModel])->()) -> (){
        //获取plist文件路径
        guard let path = NSBundle.mainBundle().pathForResource("Musics.plist", ofType: nil, inDirectory: nil) else {
            //不成功则调用block时,空数组
            resultBlock(musicModels: [QQMusicModel]())
            return
        }
        //读取plist中的数组
        guard let dataArray = NSArray(contentsOfFile: path) else {
            //不成功则调用block时,空数组
            resultBlock(musicModels: [QQMusicModel]())
            return
        }
        var tempArray = [QQMusicModel]()
        for dict in dataArray {
            let item = QQMusicModel(dict : dict as! [String : AnyObject] )
            tempArray.append(item)
        }
        //成功后,用模型数组调用block
        resultBlock(musicModels: [QQMusicModel](tempArray))
    }
}
