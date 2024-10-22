//
//  ACustomButton.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/16.
//

import UIKit


class ACustomButton: UIView {
    weak var delegate: CustomButtonDelegate?
    func didClick() {
        delegate?.CustomButtonDidClick()
    }
}
