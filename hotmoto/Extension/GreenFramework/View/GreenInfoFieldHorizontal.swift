//
//  InfoFieldHorizontal.swift
//  Green
//
//  Created by KieuVan on 2/16/17.
//  Copyright © 2017 KieuVan. All rights reserved.
//

import UIKit

open class GreenInfoFieldHorizontal: GreenView {

    @IBOutlet weak var btRight: UIButton!
    @IBOutlet weak var widthRightButton: NSLayoutConstraint!
    @IBOutlet weak var leftWidth: NSLayoutConstraint!
    @IBOutlet weak var leftView: GCleanView!
    @IBOutlet weak var rightView: GCleanView!
    
    @IBOutlet weak var tvRight: GreenTextView!
    @IBOutlet weak var tvLeft: GreenTextView!
    
    var rightHandle : (()->Void)!
    
    open var title : String
        {
        set{
            tvLeft.text = newValue
        }
        get{
            return tvLeft.text
        }
    }
    
    func enableRightButton(enable : Bool)
    {
    }
    
    @IBAction func rightTouch(_ sender: Any) {
        rightHandle()
    }
    
    func setRight(image : UIImage, handle : @escaping (()->Void))
    {
        widthRightButton.constant = 40
      //  btRight.setImage(image, for: .normal)
        self.rightHandle = handle;
        tvRight.isEditable = false ;
    }
    
    func setImageRight(image: UIImage) {
        btRight.setImage(image, for: .normal)
    }
    func showRight(enable : Bool)
    {
        widthRightButton.constant = 0
        if(enable)
        {
            widthRightButton.constant = 40

        }

    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    open var titleColor : UIColor
        {
        set{
            tvLeft.textColor = newValue
        }
        get{
            return tvLeft.textColor!
        }
    }

    func showIndicatorView()
    {
        indicatorView.isHidden = false;
        indicator.startAnimating()
    }
    
    func hideIndicatorView()
    {
        indicatorView.isHidden = true;
        indicator.stopAnimating()

    }

    
    open var contentColor : UIColor
        {
        set{
            tvRight.textColor = newValue
        }
        get{
            return tvRight.textColor!
        }
    }

    
    open var content : String
        {
        set{
            tvRight.text = newValue
        }
        get{
            return tvRight.text
        }
    }


    open func setRightColor(color : UIColor)
    {
        tvRight.textColor = color;
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override open func initStyle()
    {
        super.initStyle()
        tvRight.textContainer.lineFragmentPadding = 0;
        tvRight.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 5);
        tvLeft.textContainer.lineFragmentPadding = 0;
        tvLeft.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tvRight.contentOffset = CGPoint.init(x: 0, y: 0)
        tvRight.layer.cornerRadius = CGFloat(greenDefine.GreenRadius)
        tvLeft.isEditable = false;
        tvRight.isEditable = false;
        widthRightButton.constant = 0
        
        hideIndicatorView()

    }
    
    func setTopInsect(value : CGFloat)
    {
        tvRight.textContainer.lineFragmentPadding = 0;
        tvRight.textContainerInset = UIEdgeInsetsMake(value, 0, 0, 0);
        tvLeft.textContainer.lineFragmentPadding = 0;
        tvLeft.textContainerInset = UIEdgeInsetsMake(value, 0, 0, 0);
    }
    
    func setEditRight(value : Bool)
    {
        tvRight.isEditable = value;
    }
    
    open  func setTextStyle(_ left : TextStyle, right : TextStyle)
    {
        tvLeft.setStyle(left)
        tvRight.setStyle(right)
    }
    @IBOutlet weak var indicatorView: UIView!
    
    open  func setColor(_ left : UIColor, right : UIColor)
    {
        tvLeft.textColor = left
        tvRight.textColor = right;
    }
    
    open func setPadding(_ insets : UIEdgeInsets)
    {
        tvLeft.textContainerInset = insets;
        tvRight.textContainerInset = insets;
    }
    
    open func leftWidth(value : Float)
    {
        leftWidth.constant = CGFloat(value);
    }
    
    
}
