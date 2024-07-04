//
//  CGSize+Extensions.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/4.
//

extension CGSize: SYYCompatible {}

extension SYYable where Base == CGSize {
    var isInvalid: Bool {
        base.width < 1 || base.height < 1
    }
}
