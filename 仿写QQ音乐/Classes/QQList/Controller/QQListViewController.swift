//
//  QQListViewController.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/4.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQListViewController: UITableViewController {
    //模型数组
    var musicModels = [QQMusicModel](){
        //赋值时刷新tableView
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        QQMusicDataTool.getMusicList { (musicModels)->() in
            //给模型数组赋值
            self.musicModels = musicModels
            //拿到数据后就给播放器工具类赋值
            QQMusicOperationTool.shareInstance.musicMList = musicModels
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
// MARK: - Table view 数据源代理
extension QQListViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musicModels.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ID = "ListCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
        }
        cell?.backgroundColor = UIColor.clearColor()
        //取出对应行的模型
        let musicModel = musicModels[indexPath.row]
        //图片
        if let iconName = musicModel.icon {
            cell?.imageView?.image = UIImage(named: iconName)
        }
        //歌曲名
        cell?.textLabel?.text = musicModel.name
        cell?.textLabel?.textColor = UIColor.whiteColor()
        //歌手
        cell?.detailTextLabel?.text = musicModel.singer
        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        //圆形图片
        
        cell?.imageView?.layer.cornerRadius = 30
        cell?.imageView?.layer.masksToBounds = true
        
        return cell!
    }
    //选中后取消选中
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        QQMusicOperationTool.shareInstance.playMusic(musicModels[indexPath.row])
        performSegueWithIdentifier("jumpToDetail", sender: nil)
    }
}
//界面设置
extension QQListViewController {
    func setupInit(){
        setupTableView()
        setNavigationBar()
    }
    //设置背景,分隔线,行高
    func setupTableView() -> () {
        tableView.backgroundView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.separatorStyle = .None
        tableView.rowHeight = 60
    }
    //隐藏导航条
    func setNavigationBar() -> () {
        navigationController?.navigationBarHidden = true
    }
    //状态栏颜色
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
