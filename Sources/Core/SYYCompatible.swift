//
//  SYYCompatible.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

/// The SYYTextParsable protocol declares the required method for ``SYYTextView`` and ``SYYLabel``
/// to modify the text during editing.
/// - You can implement this protocol to add code highlighting or emoticon replacement for
///   ``SYYTextView`` and ``SYYLabel``.
public protocol SYYTextParsable {

}

/// The SYYTextLayoutType declares a readonly type stores text layout result.
/// - All the property in this type is readonly, and should not be changed.
/// - The methods in this type is thread-safe (except some of the draw methods).
public protocol SYYTextLayoutType {

}

/// The YYTextLinePositionModifier protocol declares the required method to modify
/// the line position in text layout progress.
public protocol SYYTextLinePositionModifiable {

}

/// The global namespace to nest type.
public enum SYY {
    /// The text vertical alignment.
    /// - Add `@objc` to resolve build error for **Property cannot be marked @IBInspectable because its type cannot be represented in Objective-C**.
    @objc
    public enum TextVerticalAlignment: Int {
        case top = 0, center, bottom
    }
}

extension SYY {
    public struct TextDebugOption {}
    public struct TextSimpleMarkdownParser {}
    public struct TextSimpleEmoticonParser {}
    public struct TextLinePositionSimpleModifier {}
}

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
