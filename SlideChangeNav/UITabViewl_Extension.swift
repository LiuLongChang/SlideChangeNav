//
//  UIScroll_Extension.swift
//  SlideChangeNav
//
//  Created by langyue on 16/5/17.
//  Copyright © 2016年 langyue. All rights reserved.
//

import Foundation
import UIKit



let MaxHeight : CGFloat = 200





class ScalableCover: UIImageView {
    
    
    private var _scrollView : UIScrollView?
    var scrollView:UIScrollView{
        
        set{
            
            if _scrollView != nil {
                _scrollView!.removeObserver(scrollView, forKeyPath: kContentOffset)
            }
            _scrollView = newValue
            
            if _scrollView != nil {
                _scrollView!.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
            }
            
        }
        get{
            return _scrollView!
        }
        
    }
    
    override func removeFromSuperview() {
        
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        print("---removed")
        super.removeFromSuperview()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.scrollView.contentOffset.y < 0 {
            
            let offset = -self.scrollView.contentOffset.y
            self.frame = CGRectMake(-offset, -offset, scrollView.bounds.size.width + offset * 2, MaxHeight + offset)
            
        }else{
            self.frame = CGRectMake(0, 0, scrollView.bounds.size.width, MaxHeight)
        }
        
        
    }
    
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        self.setNeedsLayout()
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .ScaleAspectFill
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




let kContentOffset = "contentOffset"
let kScalableCover = "scalableCover"




private var Person_Id_Number_Property = 0
extension UITableView{
    
    var scalableCover : ScalableCover? {
        get{
            let result = objc_getAssociatedObject(self, &Person_Id_Number_Property) as? ScalableCover
            if result == nil {
                return nil
            }
            return result!
        }
        set{
            self.willChangeValueForKey(kScalableCover)
            objc_setAssociatedObject(self, &Person_Id_Number_Property, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            self.didChangeValueForKey(kScalableCover)
        }
    }
    
    
    func addScalableCoverWithImage(image:UIImage){
        
        let cover = ScalableCover(frame:CGRectMake(0, 0, self.bounds.size.width, MaxHeight))
        cover.backgroundColor = UIColor.clearColor();
        cover.image = image;
        cover.scrollView = self
        self.addSubview(cover)
        self.sendSubviewToBack(cover)
        
        self.scalableCover = cover
    }
    
    
    func removeScalableCover(){
        self.scalableCover?.removeFromSuperview()
        self.scalableCover = nil
    }
    
}









