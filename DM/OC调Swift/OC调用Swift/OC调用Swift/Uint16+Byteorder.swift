//
//  Uint16+Byteorder.swift
//  OC调用Swift
//
//  Created by kiss on 2020/7/7.
//  Copyright © 2020 kiss. All rights reserved.
//

//import Foundation
//extension UInt16{
//     init?(data: Data, offset: Int = 0, bigEndian: Bool = true) {
//        guard offset + 2 <= data.count else {
//            return nil
//        }
//        if bigEndian {
//            self = (UInt16(data[offset]) << 8) + UInt16(data[offset + 1])
//        } else {
//            self = (UInt16(data[offset + 1]) << 8) + UInt16(data[offset])
//        }
//    }
//    
//    func data(bigEndian: Bool = true) -> Data {
//        let big = UInt8((self & 0xff00) >> 8)
//        let small = UInt8(self & 0x00ff)
//
//        let array = bigEndian ? [big, small] : [small, big]
//        return Data(array)
//    }
//}
