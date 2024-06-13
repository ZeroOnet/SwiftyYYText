//
//  SYYCompatible.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

/// The global namespace to nest type.
public enum SYY {}

public protocol SYYCompatible {}

extension SYYCompatible {
    public static var syy: SYYable<Self>.Type {
        get { SYYable<Self>.self }
        set { } // swiftlint:disable:this unused_setter_value
    }

    public var syy: SYYable<Self> {
        get { SYYable(self) }
        set { } // swiftlint:disable:this unused_setter_value
    }
}

public struct SYYable<Base> {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
