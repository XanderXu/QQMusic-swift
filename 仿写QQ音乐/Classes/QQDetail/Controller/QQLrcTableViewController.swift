//
//  QQLrcTableViewController.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit

class QQLrcTableViewController: UITableViewController {
    var dataSource : [QQLrcModel] = [QQLrcModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    var scrollRow : Int = 0 {
        didSet {
            if scrollRow != oldValue {
                //换行时刷新可见行,清除已变色单元格
                tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
                //先刷新,再滚动动画
                let indexPath = IndexPath(row: scrollRow, section: 0)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    var progress : Double = 0.0 {
        didSet {
            let index = IndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: index) as? QQLrcCell
            cell?.progress = progress
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //创建cell
        let cell = QQLrcCell.cellWithTableView(tableView)
        //对当前播放行设置进度
        if (indexPath as NSIndexPath).row == scrollRow {
            cell.progress = progress
        } else {
            cell.progress = 0.0
        }
        let model = dataSource[(indexPath as NSIndexPath).row]
        cell.lrcStr = model.lrcStr
        return cell
    }


   
}
