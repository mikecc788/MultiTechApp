//
//  KeyboardResponder.swift
//  WeiboUI
//
//  Created by app on 2022/12/6.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var keyboardheight :CGFloat = 0
    var keyboardShow: Bool { keyboardheight > 0 }
    init() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
   @objc private func keyboardWillShow(_ notification:Notification) {
       guard let frame = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else{
           return
       }
       keyboardheight = frame.height
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        
        keyboardheight = 0
     }
}

