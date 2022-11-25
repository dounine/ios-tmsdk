//
//  File.swift
//
//
//  Created by 黄焕来 on 2022/11/2.
//

import Foundation
public struct Digest {
    public let digest: [UInt8]
    
    init(_ digest: [UInt8]) {
        assert(digest.count == 16)
        self.digest = digest
    }
    
    public var checksum: String {
        return SwiftMD5().encodeMD5(digest: digest)
    }
}
