//
//  QQMusicOperationTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit
import MediaPlayer

//  负责的音乐播放的业务逻辑, 比如, 上一首,下一首,顺序播放, 随机播放等等
class QQMusicOperationTool: NSObject {
    var drawRow : Int = -1
    static let shareInstance = QQMusicOperationTool()
    //播放工具
    let tool = QQMusicTool()
    //播放列表
    var musicMList : [QQMusicModel]?
    
    var index = 0 {
        didSet {
            if index < 0 {//小于0跳到最后一首
                index = (musicMList?.count ?? 0) - 1
            }
            if index > ((musicMList?.count ?? 0) - 1) {//大于最后一首跳到0
                index = 0
            }
        }
    }
    //按模型播放
    func playMusic(musicM : QQMusicModel) -> () {
        let fileName = musicM.filename ?? ""
        tool.playMusic(fileName)
        index = (musicMList?.indexOf(musicM)) ?? 0//获取当前歌曲模型在播放列表中的位置
        if musicMList == nil {
            print("没有播放列表,只能播放一首歌曲")
            return
        }
    }
    //继续播放
    func playCurrentMusic() -> () {
        tool.resumeCurrentMusic()
    }
    //暂停播放
    func pauseCurrentMusic() -> () {
        tool.pauseCurrentMusic()
    }
    //下一曲
    func nextMusic() -> () {
        index += 1
        if let tempList = musicMList {
            let musicM = tempList[index]
            playMusic(musicM)
        }
    }
    //上一曲
    func preMusic() -> () {
        index -= 1
        if let tempList = musicMList {
            let musicM = tempList[index]
            playMusic(musicM)
        }
    }
    //跳转到
    func seekTo(interval : NSTimeInterval) -> () {
        tool.seekTo(interval)
    }
    //私有变量
    private var musicInfoModel = QQMusicInfoModel()
    private var artwork : MPMediaItemArtwork?
}
extension QQMusicOperationTool {
    ///当前歌曲的详情模型
    func getNewMusicInfoModel() -> QQMusicInfoModel {
        musicInfoModel.musicM = musicMList?[index]
        musicInfoModel.costTime = tool.player?.currentTime ?? 0
        musicInfoModel.totalTime = tool.player?.duration ?? 0
        musicInfoModel.isPlaying = tool.player?.playing ?? false
        return musicInfoModel
    }
}