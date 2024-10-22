//
//  INNPOP.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit

public struct INNPOP<Base>{
    let base:Base
    init(_ base : Base){
        self.base = base
    }
}
public protocol INNPOPCompatible {}

public extension INNPOPCompatible {
    static var inn:INNPOP<Self>.Type{
        get{INNPOP<Self>.self}
        set{}
    }
    var inn: INNPOP<Self> {
        get { INNPOP(self) }
        set {}
    }
}

/// Define Property protocol
internal protocol INNSwiftPropertyCompatible {
  
    /// Extended type
    associatedtype T
    
    ///Alias for callback function
    typealias SwiftCallBack = ((T?) -> ())
    
    ///Define the calculated properties of the closure type
    var swiftCallBack: SwiftCallBack?  { get set }
}
