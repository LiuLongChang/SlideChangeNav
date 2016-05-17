//
//  TeachHomePageMoreVC.swift
//  SlideChangeNav
//
//  Created by langyue on 16/5/16.
//  Copyright © 2016年 langyue. All rights reserved.
//

import UIKit

class TeachHomePageMoreVC: UIViewController,UIScrollViewDelegate {

    
    var navView : UIToolbar?
    var backScrollView : UIScrollView!
    
    
    var bgTabView : UITableView!
    
    var headView:TeachHomePageMoreView!
    
    
    
    var arrs = ["商品","评论","更多"]
    
    var toorView:UIView!
    var toorViewH:UIToolbar!
    var scrollLineView:UIView!
    var scrollLineViewH:UIView!
    
    
    var firstVC : InfoViewController?
    var secondVC : TutorViewController?
    var threeVC : BlessViewController?
    
    
    var isScroll:Bool = true
    var oldF:CGFloat = 0.0
    var originW:CGFloat = UIScreen.mainScreen().bounds.size.width/7
    var s:NSInteger = 0
    
    
    deinit{
        firstVC?.removeObserver(self, forKeyPath: "offerY")
        secondVC?.removeObserver(self, forKeyPath: "offerY")
        threeVC?.removeObserver(self, forKeyPath: "offerY")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navTitleView()
        self.addController()
        self.addButton()
        
        let vc: InfoViewController = self.childViewControllers.first! as! InfoViewController
        vc.view.frame = self.backScrollView.bounds
        self.backScrollView.addSubview(vc.view)
        
    }
    
    
    
    func addController(){
        
        let vc:InfoViewController = InfoViewController()
        weak var weakSelf = self
        vc.firstBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc.view.backgroundColor = UIColor.whiteColor()
        firstVC = vc
        firstVC?.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.New, context: nil)
        self.addChildViewController(vc)
        vc.view.frame = CGRectMake(0, 0, kWidth, kHeight-200-64-40)
        self.backScrollView.addSubview(vc.view)
        
        
        
        
        let vc2: TutorViewController = TutorViewController()
        vc2.secondBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc2.view.backgroundColor = UIColor.whiteColor()
        secondVC = vc2
        secondVC?.addObserver(self, forKeyPath: "offerY", options: NSKeyValueObservingOptions.New, context: nil)
        self.addChildViewController(vc2)
        vc2.view.frame = CGRectMake(kWidth, 0, kWidth,kHeight-200-64-40)
        self.backScrollView.addSubview(vc2.view)
        
        
        
        
        
        let vc3:BlessViewController = BlessViewController()
        vc3.threeBlock = {(isScroll:Bool)->Void in
            self.isScroll = isScroll
            weakSelf?.isTouchToButton()
        }
        vc3.view.backgroundColor = UIColor.whiteColor()
        threeVC = vc3
        threeVC?.addObserver(self, forKeyPath: "offerY", options: .New, context: nil)
        self.addChildViewController(vc3)
        vc3.view.frame = CGRectMake(2*kWidth, 0, kWidth,kHeight-200-64-40)
        self.backScrollView.addSubview(vc3.view)
        
        
    }
    
    
    //FIXME:KVO接收
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        let offsetY = change?["new"] as! CGFloat
        let s = offsetY - oldF
        oldF = offsetY
        
        
        
        self.toorView.frame.origin.y -= s
        
        if offsetY >= 136 {
            //self.toorViewH.hidden = false
        }else{
            //self.toorViewH.hidden = true
        }
        
        
        if offsetY > 0 {
            self.navView?.alpha = (offsetY-10)/100
        }else if(offsetY == 0){
            UIView.animateWithDuration(0.23, animations: {
                self.navView?.alpha = (offsetY-10)/100
            })
        }
        
    }
    
    
    
    
    //FIXME: 导航条
    func navTitleView(){
        
        
        bgTabView = UITableView(frame: CGRectMake(0, 0, kWidth, kHeight))
        bgTabView.showsHorizontalScrollIndicator = false
        bgTabView.showsVerticalScrollIndicator = false
        headView = NSBundle.mainBundle().loadNibNamed("TeachHomePageMoreView", owner: self, options: nil).last as! TeachHomePageMoreView
        headView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 200)
        bgTabView.tableHeaderView = headView
        bgTabView.addScalableCoverWithImage(UIImage(named: "OrganizerHeadImage")!)
        self.view.addSubview(bgTabView)
        
        
        
        navView = UIToolbar(frame:CGRectMake(0,0,kWidth,64))
        navView?.backgroundColor = UIColor.whiteColor()
        navView?.layer.shadowColor = UIColor.grayColor().CGColor
        navView?.layer.shadowOpacity = 0.5
        navView?.layer.shadowOffset = CGSize(width: 0,height: 0.2)
        
        
        let titleLabel = UILabel(frame: CGRect(x:0,y:15,width: kWidth,height: 64))
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = "个人主页"
        titleLabel.font = UIFont.boldSystemFontOfSize(17.0)
        titleLabel.textAlignment = .Center
        navView?.addSubview(titleLabel)
        navView?.alpha = 0
        self.view.addSubview(navView!)
        
        
        
        toorView = UIView(frame:CGRectMake(0,200,kWidth,40))
        toorView.backgroundColor = UIColor(colorLiteralRed: 245/255.0,green: 245/255.0,blue: 245/255.0,alpha:1)
        toorView.layer.shadowColor = UIColor.grayColor().CGColor
        self.view.insertSubview(toorView, aboveSubview: self.bgTabView)
        
        
        scrollLineView = UIView(frame:CGRect(x: originW,y: 37,width: originW,height: 3))
        scrollLineView.backgroundColor = UIColor.greenColor()
        toorView.addSubview(scrollLineView)
        
        
        backScrollView = UIScrollView(frame:CGRectMake(0,240,kWidth,kHeight-200-44))
        bgTabView.addSubview(backScrollView)
        backScrollView.contentSize = CGSizeMake(3*kWidth, 0)
        backScrollView.pagingEnabled = true
        backScrollView.alwaysBounceHorizontal = true
        
    }
    
    
    func addButton(){
        
        for i in 0...arrs.count-1 {
            let W:CGFloat = originW
            let H:CGFloat = 40
            let Y:CGFloat = 0
            let X:CGFloat = CGFloat(i) * (W + originW) + W
            
            
            let button:UIButton = UIButton()
            button.frame = CGRect(x: X,y: Y,width: W,height: H)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(arrs[i], forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(15.0)
            button.tag = i
            button.addTarget(self, action: #selector(TeachHomePageMoreVC.buttonAction(_:)), forControlEvents: .TouchUpInside)
            self.toorView.addSubview(button)
            
        }
        
    }
    
    
    
    func buttonAction(sender:UIButton){
        
        UIView.animateWithDuration(0.3) {
            self.scrollLineView.frame.origin.x  = CGFloat(sender.tag) * (self.originW + self.originW) + self.originW
        }
        
        let selectedVC:UIViewController = self.childViewControllers[sender.tag]
        if selectedVC.view.superview == nil {
            self.backScrollView.setContentOffset( CGPointMake(kWidth*(CGFloat(sender.tag)), 0), animated: true)
        }
        
    }
    
    
    
    func isTouchToButton(){
        
        if self.isScroll == true {
            self.toorView.userInteractionEnabled = true
        }else{
            self.toorView.userInteractionEnabled = false
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
