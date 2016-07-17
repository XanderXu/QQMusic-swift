//
//  QQDetailViewController.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/4.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQDetailViewController: UIViewController {
    var timer : NSTimer?
    var displayLink : CADisplayLink?
    lazy var lrcTVC : QQLrcTableViewController = {
        let lrcTVC = QQLrcTableViewController()
        return lrcTVC
    }()
       //切换时加载一次
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var lrcScrollView: UIScrollView!
    
    //多次刷新
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOnce()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(nextBtnClick(_:)), name: kPlayerDidFinishPlaying, object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFrame()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupDataOnce()
        setupDataTimes()
        addSecondTimer()
        addDisplayLink()
    }
    override func viewWillDisappear(animated: Bool) {
        removeTimer()
        removeDisplayLink()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

}
//界面点击,滑动事件处理
extension QQDetailViewController {
    //播放暂停
    @IBAction func playPauseBtnClick(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected == true {
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            pauseRotationAnimation()
        } else {
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            resumeRotationAnimation()
        }
    }
    //上一首
    @IBAction func preBtnClick(sender: AnyObject) {
        QQMusicOperationTool.shareInstance.preMusic()
        setupDataOnce()
    }
    //下一首
    @IBAction func nextBtnClick(sender: AnyObject) {
        QQMusicOperationTool.shareInstance.nextMusic()
        setupDataOnce()
    }
    //返回
    @IBAction func backToListBtnClick(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    //进度条拖动
    @IBAction func sliderChange(sender: UISlider) {
        let totalTime = QQMusicOperationTool.shareInstance.getNewMusicInfoModel().totalTime
        let currentTime = Double(sender.value) * totalTime
        currentTimeLabel.text = QQTimeTool.getFormatTime(currentTime)
        QQMusicOperationTool.shareInstance.seekTo(currentTime)
    }
    
    func sliderTap(tap : UIGestureRecognizer) -> () {
        let point = tap.locationInView(progressSlider)
        let value = point.x / progressSlider.width
        progressSlider.value = Float(value)
        let totalTime = QQMusicOperationTool.shareInstance.getNewMusicInfoModel().totalTime
        let currentTime = Double(value) * totalTime
        QQMusicOperationTool.shareInstance.seekTo(currentTime)
    }

}
//界面和数据加载
extension QQDetailViewController {
    func setupOnce() -> () {
        //歌词tableView
        lrcTVC.tableView.backgroundColor = UIColor.clearColor()
        lrcScrollView.addSubview(lrcTVC.tableView)
        lrcScrollView.pagingEnabled = true
        lrcScrollView.showsHorizontalScrollIndicator = false
        lrcScrollView.delegate = self
        //进度slider
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), forState: .Normal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sliderTap(_:)))
        progressSlider.addGestureRecognizer(tap)
        
    }
    func setupFrame() -> () {
        //前景图片
        foregroundImageView.layer.cornerRadius = foregroundImageView.frame.width * 0.5
        foregroundImageView.layer.masksToBounds = true
        //歌词列表
        lrcTVC.tableView.frame = lrcScrollView.bounds
        lrcTVC.tableView.x = lrcScrollView.width
        lrcScrollView.contentSize = CGSize(width: lrcScrollView.width * 2, height: 0)
    }
    func setupDataOnce() -> () {
        //得到歌曲详情的模型
        let musicInfoM = QQMusicOperationTool.shareInstance.getNewMusicInfoModel()
        //根据模型设置界面数据
        let imageName = musicInfoM.musicM?.icon ?? ""
        backgroundImageView.image = UIImage(named: imageName)
        foregroundImageView.image = UIImage(named: imageName)
        singerLabel.text = musicInfoM.musicM?.singer
        nameLabel.text = musicInfoM.musicM?.name
        totalTimeLabel.text = musicInfoM.totalTimeFormat
        //获取歌词,并传给lrcTVC
        let lrcModels = QQLrcDataTool.getLrcModels(musicInfoM.musicM?.lrcname)
        lrcTVC.dataSource = lrcModels
        //旋转动画
        addRotationAnimation()
        if musicInfoM.isPlaying {
            resumeRotationAnimation()
        } else {
            pauseRotationAnimation()
        }

    }
    func setupDataTimes() -> () {
        //得到歌曲详情的模型
        let musicInfoM = QQMusicOperationTool.shareInstance.getNewMusicInfoModel()
        currentTimeLabel.text = musicInfoM.costTimeFormat
        progressSlider.value = Float(musicInfoM.costTime / musicInfoM.totalTime)
        
    }
    func updateLrc() -> () {
        //得到歌曲详情的模型
        let musicInfoM = QQMusicOperationTool.shareInstance.getNewMusicInfoModel()
        //拿到行号和歌词模型
        let rowAndLrcM = QQLrcDataTool.getRowAndLrcM(musicInfoM.costTime, lrcModels: lrcTVC.dataSource)
        //更新行号
        lrcTVC.scrollRow = rowAndLrcM.row
        //歌词内容更新
        let lrcM = rowAndLrcM.lrcM
        lrcLabel.text = lrcM.lrcStr
        //歌词进度更新
        let value = (musicInfoM.costTime - lrcM.beginTime) / (lrcM.endTime - lrcM.beginTime)
        lrcLabel.progress = value
        lrcTVC.progress = value
        
    }
    func addSecondTimer() -> () {
        timer = NSTimer(timeInterval: 1, target: self, selector: #selector(setupDataTimes), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    func addDisplayLink() -> () {
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    func removeTimer() -> () {
        timer?.invalidate()
        timer = nil
    }
    func removeDisplayLink() -> () {
        displayLink?.invalidate()
        displayLink = nil
    }
    func addRotationAnimation() -> () {
        //前景图片旋转
        foregroundImageView.layer.removeAnimationForKey("rotation")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 30
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.repeatCount = MAXFLOAT
        //播放完成或者返回主页后不移除
        animation.removedOnCompletion = false
        foregroundImageView.layer.addAnimation(animation, forKey: "rotation")
    }
    func resumeRotationAnimation() -> () {
        foregroundImageView.layer.resumeAnimate()
    }
    func pauseRotationAnimation() -> () {
        foregroundImageView.layer.pauseAnimate()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
extension QQDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let alpha = 1 - scrollView.contentOffset.x / lrcScrollView.width
        foregroundImageView.alpha = alpha
        lrcLabel.alpha = alpha
    }
}