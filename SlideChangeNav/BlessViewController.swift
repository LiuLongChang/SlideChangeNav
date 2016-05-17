//
//  BlessViewController.swift
//  SlideChangeNav
//
//  Created by langyue on 16/5/16.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit


typealias BlessBlock = (blessBlock:Bool)->Void


class BlessViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    
    var tbView:UITableView!
    dynamic var offerY:CGFloat = 0.0
    var headView:TeachHomePageMoreView!
    var threeBlock:BlessBlock?
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createTableView()
        
        // Do any additional setup after loading the view.
    }

    
        //FIXME:-----接收的通知
    func notiAction(notification:NSNotification){
        var dic = notification.userInfo
        let y:CGFloat = (dic!["infoY"] as? CGFloat)!
        if y >= 136 {
            if tbView.contentOffset.y < 136 {
                tbView.contentOffset.y = 136
            }
        }else{
            tbView.contentOffset.y = y
        }
    }
    
    
    
    func createTableView(){
        
        tbView = UITableView(frame: CGRect(x: 0,y: 0,width: kWidth,height: kHeight-200-44),style:.Grouped)
        tbView.dataSource = self
        tbView.delegate = self
        self.view.addSubview(tbView!)
        
                
        
        self.tbView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BlessViewController.notiAction(_:)), name: "infoSwift", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BlessViewController.notiAction(_:)), name: "turorSwift", object: nil)
        
    }
    
    //FIXME:-----tableView delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identity : String = "cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identity, forIndexPath: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .Default,reuseIdentifier: identity)
        }
        cell.textLabel?.text = "FEI   ->\(indexPath.row)"
        if indexPath.row % 3 == 0 {
            cell.backgroundColor = UIColor.purpleColor()
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 40
        }else{
            
            return 50
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    
    //FIXME:-----scrollView delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.offerY = scrollView.contentOffset.y
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if threeBlock != nil {
            threeBlock!(blessBlock:true)
        }
        
        let offer:CGFloat = scrollView.contentOffset.y
        tbView.contentOffset.y = offer
        var dic:Dictionary<String,CGFloat> = Dictionary()
        dic["infoY"] = offer
        NSNotificationCenter.defaultCenter().postNotificationName("BlessSwift", object: nil, userInfo: dic)
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if threeBlock != nil {
            threeBlock!(blessBlock:false)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
