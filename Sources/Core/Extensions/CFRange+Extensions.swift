//
//  CFRange+Extensions.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/17.
//

extension CFRange: SYYCompatible {}

extension SYYable where Base == CFRange {
    var range: NSRange { .init(location: base.location, length: base.length) }
}
