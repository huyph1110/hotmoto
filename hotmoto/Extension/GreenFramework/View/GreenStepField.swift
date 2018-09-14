//
//  GreenStepField.swift
//  Hey_Go
//
//  Created by Lê Dũng on 5/29/17.
//  Copyright © 2017 NCSoft. All rights reserved.
//

import UIKit

class GreenStepField: GreenView, UITextFieldDelegate {
    
    @IBOutlet weak var tfContent: UITextField!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var rightView: GreenButtonCenter!
    @IBOutlet weak var leftView: GreenButtonCenter!
    var actionHandle : ((Int) -> Void)!
    
    var min = 0
    var max = 0
    var step = 0
    
    private func validate()
    {
        if(value > max )
        {
            value = max;
        }
        if(value < min)
        {
            value = min
        }
        tfContent.text = String(value)
    }
    
    override func initStyle()
    {
        self.layer.cornerRadius = greenDefine.GreenInfoFieldStep_Radius
        self.clipsToBounds = true;
        self.view.backgroundColor = greenDefine.GreenInfoFieldStep_BackgroundColor
        self.backgroundColor = greenDefine.GreenInfoFieldStep_BackgroundColor
        tfContent.textColor = greenDefine.GreenInfoFieldStep_TextColor
        weak var weakSelf : GreenStepField!  = self
        tfContent.delegate = self
        tfContent.keyboardType = .numberPad
        
        leftView.setTarget(greenDefine.GreenInfoFieldStep_LeftImage.tint(greenDefine.GreenInfoFieldStep_ButtonTintColor)) { (button) in
            weakSelf.value = weakSelf.value - weakSelf.step;
            
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.value)
            }
        }
        let decresePress = UILongPressGestureRecognizer(target: self, action: #selector(GreenStepField.decreasePress))
        leftView.addGestureRecognizer(decresePress)
        
        
        
        rightView.setTarget(greenDefine.GreenInfoFieldStep_RightImage.tint(greenDefine.GreenInfoFieldStep_ButtonTintColor)) { (button) in
            weakSelf.value = weakSelf.value + weakSelf.step;
            if(weakSelf.actionHandle != nil)
            {
                weakSelf.actionHandle(weakSelf.value)
            }
        }
        let incresePress = UILongPressGestureRecognizer(target: self, action: #selector(GreenStepField.incresePress))
        rightView.addGestureRecognizer(incresePress)
        
        
        tfContent.textAlignment = .center;
    }
    
    @objc func decreasePress(tap : UILongPressGestureRecognizer) {
        if tap.state == .began {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                if timer.isValid {
                    self.value = self.value - self.step;
                }
            })
        }
        if tap.state == .ended {
            timer?.invalidate()
            actionHandle(self.value)
            
        }
    }
    var timer: Timer?
    
    @objc func incresePress(tap : UILongPressGestureRecognizer) {
        if tap.state == .began {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                if timer.isValid {
                    self.value = self.value + self.step;
                    
                }
            })
            
        }
        
        if tap.state == .ended {
            timer?.invalidate()
            actionHandle(self.value)
        }
    }
    //-------------------------------------------------------Public function
    open func target(action :  @escaping ((Int)-> Void))
    {
        self.actionHandle = action ;
    }
    
    open var value: Int = 0
        {
        didSet
        {
            tfContent.text = String(value)
            validate()
        }
    }
    
    public func textColor(color : UIColor)
    {
        tfContent.textColor = color
    }
    
    public func tintColor(color : UIColor)
    {
        leftView.setImage(greenDefine.GreenInfoFieldStep_LeftImage.tint(color))
        rightView.setImage(greenDefine.GreenInfoFieldStep_RightImage.tint(color))
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        if string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) != nil {
            return false
        }
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            let val = Int(updatedText)
            if val! >= max {
                value = max
                return false
            }
            if val! <= min {
                value = min
                return false
            }
        }
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.length == 0 {
            value = min
        }else {
            
        }
        if(actionHandle != nil)
        {
            actionHandle(value)
        }
        
    }
}
