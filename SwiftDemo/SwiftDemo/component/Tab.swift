//
//  Tab.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/28.
//

import Foundation
import UIKit
import SnapKit
class Tab:UIView{
    var items:[String]
    var itemButtons:[UIButton]
    var selectedItemButton: UIButton!
    
    var indicatorView: UIView!
    
    var selectedColor: UIColor? {
        didSet{
            
        }
    }
    var normalColor: UIColor?
    
    init?(items:[String]){
        if items.count == 0{
            return nil
        }
        self.items = items
        itemButtons = []
        super.init(frame: .zero)
        self.createViews()
    }
     
    func createViews(){
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
