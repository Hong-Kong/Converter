//
//  HKZKeyboard.swift
//  Converter
//
//  Created by  on 17/7/6.
//  Copyright © 2017年 HK. All rights reserved.
//

import UIKit

protocol HKZKeyboardProtocol {
    func HKZKeyboardTapped(button:UIButton, number:String)
    func HKZKeyboardEndEditing()
}


let doneKey = 618, deleteKey = 619, clearKey = 361

class HKZKeyboard: UIView {
    // MARK:init
    
    init(frame: CGRect, style:BaseNumberType) {
        self.keyBoardStlyle = style
        super.init(frame: frame)

        var height:CGFloat = 0, keyHeight = kScreenWith/5.0;
        switch keyBoardStlyle {
        case .binary:
            height = keyHeight;
        case .octal:
            height = keyHeight*3;
        case .decimal:
            height = keyHeight*4;
        case .hexadecimal:
            height = keyHeight*4;
        }
        self.frame.size.width = kScreenWith
        self.frame.size.height = height;
        self.backgroundColor = UIColor.blue
        self.setupButtons()
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
    required init?(coder: NSCoder) {
        self.keyBoardStlyle = .decimal
        super.init(coder: coder)
    }
    
    // MARK: Properties
    
    var delegate:HKZKeyboardProtocol?
    var keyBoardStlyle:BaseNumberType
    
    
    func setupButtons() {
        var numbers = [[String]]()
        
        let binaryKeys = [["0","1","收","清空","x"]];
        
        let octalKeys = [["4","5","6","7"],
                         ["0","1","2","3"],
                         ["","收","清空","x"]]
        
        let decimalKeys = [["7","8","9"],
                           ["4","5","6"],
                           ["1","2","3"],
                           ["清空","0","x"]]
        
        let hexKeys = [["7","8","9","A","B"],
                       ["4","5","6","C","D"],
                       ["1","2","3","E","F"],
                       ["0","","收","清空","x"]];
        
        switch keyBoardStlyle {
        case .binary:
            numbers = binaryKeys
        case .octal:
            numbers = octalKeys
        case .decimal:
            numbers = decimalKeys
        case .hexadecimal:
            numbers = hexKeys
        }
        
        for i in 0..<numbers.count {
            for j in 0..<numbers[i].count {
                let columns = numbers[0].count
                let width:CGFloat = kScreenWith/CGFloat(columns) ,height = kScreenWith/5.0
                let left:CGFloat = CGFloat(j)*width;
                let top = CGFloat(i)*height
                
                let btn:UIButton = UIButton()
                btn.frame = CGRect(x: left, y: top, width: width, height: height)
                btn.setTitle(numbers[i][j], for:UIControlState.normal)
                btn.backgroundColor = UIColor.white
                
                btn.setBackgroundImage(getImageWithColor(color: UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)), for: UIControlState.highlighted)
                    
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitleColor(UIColor.blue, for: .highlighted)
                btn.layer.borderWidth = 0.5;
                let color = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 255.0/255.0, alpha: 1) // ghostWhite
                btn.layer.masksToBounds = false
                btn.layer.borderColor = color.cgColor
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                btn.addTarget(self, action:#selector(btnClicked(btn:)), for: .touchUpInside)
                
                switch keyBoardStlyle {
                case .binary:
                    if (i==0 && j == 4) {
                        btn.tag = deleteKey
                    }else if (i == 0 && j == 3){
                        btn.tag = clearKey
                    }else if (i == 0 && j == 2){
                        btn.tag = doneKey
                    }
                case .octal:
                    if (i==2 && j == 3) {
                        btn.tag = deleteKey
                    }else if (i == 2 && j == 2){
                        btn.tag = clearKey
                    }else if (i == 2 && j == 1){
                        btn.tag = doneKey
                    }

                case .decimal:
                    if (i==3 && j == 2) {
                        btn.tag = deleteKey
                    }else if (i == 3 && j == 0){
                        btn.tag = clearKey
                    }
                case .hexadecimal:
                    if (i==3 && j == 4) {
                        btn.tag = deleteKey
                    }else if (i == 3 && j == 3){
                        btn.tag = clearKey
                    }else if (i == 3 && j == 2){
                        btn.tag = doneKey
                    }
                }

                
                
                self.addSubview(btn)
            }
        }
    }
   
    
    func btnClicked(btn:UIButton) {
        if btn.tag==doneKey {
            self.delegate?.HKZKeyboardEndEditing()
            return
        }
        
        self.delegate?.HKZKeyboardTapped(button: btn, number: btn.currentTitle!)
        
    }
    
    
    func getImageWithColor(color:UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
}

