//
//  GreenExtention+UILabel.swift
//  Green
//
//  Created by KieuVan on 2/15/17.
//  Copyright © 2017 KieuVan. All rights reserved.TT
//

import UIKit
public extension UILabel
{
    public func setStyle(_ style : TextStyle)
    {
        self.font = greenDefine.getFontStyle(style).font
        self.textColor = greenDefine.getFontStyle(style).color
    }
    
    public func setBold()
    {
        self.font = UIFont(name: greenDefine.GreenFontBold.fontName, size: self.font.pointSize)
    }
    func addAttributeString(_ attribute: NSAttributedString) {
        let current : NSMutableAttributedString
        if let attribute = self.attributedText{
            current = NSMutableAttributedString.init(attributedString: attribute)
        }
        else {
            current = NSMutableAttributedString()
        }
        current.append(attribute)
        self.attributedText = current

    }
    func addAttributeText(text: String, font: UIFont, color: UIColor ) {
        let current : NSMutableAttributedString
        if let attribute = self.attributedText{
            current = NSMutableAttributedString.init(attributedString: attribute)
        }
        else {
            current = NSMutableAttributedString()
        }
        let attributes = [ NSAttributedStringKey.foregroundColor: color,NSAttributedStringKey.font: font ]
        let newAttributeString = NSAttributedString(string: text, attributes: attributes)
        current.append(newAttributeString)
        self.attributedText = current
    }
    func addAttachemtText(text: NSTextAttachment, font: UIFont ) {
        let current : NSMutableAttributedString
        if let attribute = self.attributedText{
            current = NSMutableAttributedString.init(attributedString: attribute)
        }
        else {
            current = NSMutableAttributedString()
        }
        let newAttributeString = NSAttributedString.init(attachment: text)
        current.append(newAttributeString)
        self.attributedText = current
    }
}


class UILabelGeneral : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()

    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelSub : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}

class UILabelHighlight : UILabel
{
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        
    }
    
    func style()
    {
        self.textColor = greenDefine.GreenGeneralTextColor
    }
}
