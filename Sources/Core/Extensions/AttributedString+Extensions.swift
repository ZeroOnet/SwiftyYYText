//
//  AttributedString+Extensions.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

import UIKit

extension NSAttributedString: SYYCompatible {}

// MARK: - NSAttributedString serialization
extension SYYable where Base: NSAttributedString {
    /// Archive the string to data.
    func data() throws -> Data {
        .init()
    }

    /// Unarchive string from data.
    static func from(data: Data) throws -> Base {
        .init()
    }
}

// MARK: - NSAttributedString character attribute getters
extension SYYable where Base: NSAttributedString {
    /// Returns the attributes for the character at the specified index.
    /// - Parameter location: The index for which to return attributes. This value must lie within the bounds of the receiver.
    /// - Returns: The attributes for the character at index.
    func attributes(at location: Int = 0) -> [Base.Key: Any]? {
        // TODO: - 当 location 与 length 相等时，自动减一？
        guard base.length > 0, location < base.length else { return nil }
        return base.attributes(at: location, effectiveRange: nil)
    }
    
    /// Returns the value for the attribute with the specified name of the character at the specified index.
    /// - Parameters:
    ///   - attrName: The name of an attribute.
    ///   - location: The index at which to test for attributeName.
    /// - Returns: The value for the attribute named attributeName of the character at index, or nil if there is no such attribute.
    func attribute(_ attrName: Base.Key, at location: Int = 0) -> Any? {
        // TODO: - 当 location 与 length 相等时，自动减一？
        guard base.length > 0, location < base.length else { return nil }
        return base.attribute(attrName, at: location, effectiveRange: nil)
    }
    
    /// Returns the font of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.font.
    /// - Returns: The font for the character at index.
    func font(at location: Int = 0) -> UIFont? {
        attribute(.font, at: location) as? UIFont
    }

    /// Returns the kerning adjustment between characters.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.kern.
    /// - Returns: The kerning adjustment for the character at index.
    func kern(at location: Int = 0) -> CGFloat? {
        attribute(.kern, at: location) as? CGFloat
    }
    
    /// Returns the text color of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.foregroundColor.
    /// - Returns: The text color for the character at index.
    func textColor(at location: Int = 0) -> UIColor? {
        attribute(.foregroundColor, at: location) as? UIColor
    }

    /// Returns the color of the background behind the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.backgroundColor.
    /// - Returns: The color of the background behind the character at index.
    func backgroundColor(at location: Int = 0) -> UIColor? {
        attribute(.backgroundColor, at: location) as? UIColor
    }

    /// Returns the stroke width of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.strokeWidth.
    /// - Returns: The stroke width for the character at index.
    func strokeWidth(at location: Int = 0) -> CGFloat? {
        attribute(.strokeWidth, at: location) as? CGFloat
    }

    /// Returns the stroke color of the text
    /// - Parameter location: The index at which to test for NSAttributedString.Key.strokeColor.
    /// - Returns: The stroke color for the character at index.
    func strokeColor(at location: Int = 0) -> UIColor? {
        attribute(.strokeColor, at: location) as? UIColor
    }
    
    /// Returns the shadow of the text
    /// - Parameter location: The index at which to test for NSAttributedString.Key.shadow.
    /// - Returns: The shadow for the character at index.
    func shadow(at location: Int = 0) -> NSShadow? {
        attribute(.shadow, at: location) as? NSShadow
    }
    
    /// Returns the strikethrough style of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.strikethroughStyle.
    /// - Returns: The strikethrough style for the character at index.
    func strikethroughStyle(at location: Int = 0) -> NSUnderlineStyle? {
        attribute(.strikethroughStyle, at: location) as? NSUnderlineStyle
    }

    /// Returns the strikethrough color of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.strikethroughColor.
    /// - Returns: The strikethrough color for the character at index.
    func strikethroughColor(at location: Int = 0) -> UIColor? {
        attribute(.strikethroughColor, at: location) as? UIColor
    }

    /// Returns the underline style of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.underlineStyle.
    /// - Returns: The underline style for the character at index.
    func underlineStyle(at location: Int = 0) -> NSUnderlineStyle? {
        attribute(.underlineStyle, at: location) as? NSUnderlineStyle
    }

    /// Returns the underline color of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.underlineColor.
    /// - Returns: The underline color for the character at index.
    func underlineColor(at location: Int = 0) -> UIColor? {
        attribute(.underlineColor, at: location) as? UIColor
    }

    /// Returns the ligature of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.ligature.
    /// - Returns: The ligature for the character at index.
    func ligature(at location: Int = 0) -> Int? {
        // TODO: - 存在系统限制，转换为实际语义下的枚举类型
        attribute(.ligature, at: location) as? Int
    }
    
    /// Returns the effect of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.textEffect.
    /// - Returns: The effect for the character at index.
    func textEffect(at location: Int = 0) -> String? {
        attribute(.textEffect, at: location) as? String
    }
    
    /// Retruns the vertical offset for the position of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.baselineOffset.
    /// - Returns: The offset from the baseline for the character at index.
    func baselineOffset(at location: Int = 0) -> CGFloat? {
        attribute(.baselineOffset, at: location) as? CGFloat
    }
    
    /// Returns the paragraph style of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The paragraph style for the character at index.
    func paragraphStyle(at location: Int = 0) -> NSParagraphStyle {
        // TODO: - NSParagraphStyle 不能与 CTParagraphStyleRef toll-free bridged？
        // TODO: - 需要默认转换为
        (attribute(.paragraphStyle, at: location) as? NSParagraphStyle) ?? .default
    }
}

extension SYY {
    public struct TextShadow: Codable {}
    public struct TextDecoration: Codable {}
    public struct TextBorder: Codable {}
    public struct TextBackedString: Decodable {
        public let value: String
    }
}
// MARK: - Extended NSAttributedString character attribute by SwiftyText
extension SYYable where Base: NSAttributedString {
    /// Returns the shadow of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.shadow.
    /// - Returns: The shadow for the character at index.
    func shadow(at location: Int = 0) -> SYY.TextShadow? {
        attribute(.syy.shadow, at: location) as? SYY.TextShadow
    }

    /// Returns the inner shadow of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.innerShadow.
    /// - Returns: The inner shadow for the character at index.
    func innerShadow(at location: Int = 0) -> SYY.TextShadow? {
        attribute(.syy.innerShadow, at: location) as? SYY.TextShadow
    }

    /// Returns the underline of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.underline.
    /// - Returns: The underline for the character at index.
    func underline(at location: Int = 0) -> SYY.TextDecoration? {
        attribute(.syy.underline, at: location) as? SYY.TextDecoration
    }

    /// Returns the strikethrough of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.strikethrough.
    /// - Returns: The strikethrough for the character at index.
    func strikethrough(at location: Int = 0) -> SYY.TextDecoration? {
        attribute(.syy.strikethrough, at: location) as? SYY.TextDecoration
    }

    /// Returns the border of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.border.
    /// - Returns: The border for the character at index.
    func border(at location: Int = 0) -> SYY.TextBorder? {
        attribute(.syy.border, at: location) as? SYY.TextBorder
    }

    /// Returns the background border of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.backgroundBorder.
    /// - Returns: The background border for the character at index.
    func backgroundBorder(at location: Int = 0) -> SYY.TextBorder? {
        attribute(.syy.backgroundBorder, at: location) as? SYY.TextBorder
    }

    /// Returns the glyph transform of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.syy.glyphTransform.
    /// - Returns: The glyph transform for the character at index.
    func glyphTransform(at location: Int = 0) -> CGAffineTransform? {
        attribute(.syy.glyphTransform, at: location) as? CGAffineTransform
    }
    
    /// Returns the plain text from a range.
    /// - Parameter range: The range at which to test for NSAttributedString.Key.syy.backedString.
    /// - Returns: The plain text at the range.
    // TODO: - 作用是什么？
    func backedString(forRange range: NSRange) -> String? {
        guard range.location != NSNotFound, range.length != NSNotFound, range.length != 0 else { return nil }
        let string = base.string
        var result = ""
        base.enumerateAttribute(.syy.backedString, in: range) { value, _, _ in
            if let model = value as? SYY.TextBackedString, !model.value.isEmpty {
                result += model.value
            } else {
                // TODO: - 测试是否有问题
                let lowerBound = string.index(string.startIndex, offsetBy: range.location)
                let upperBound = string.index(lowerBound, offsetBy: range.length)
                result += String(string[lowerBound..<upperBound])
            }
        }
        return result
    }
}

// MARK: - Create attachment string for YYText
extension SYYable where Base: NSAttributedString {
    static func attachmentString(
        _ content: String,
        contentMode: UIView.ContentMode,
        width: CGFloat,
        ascent: CGFloat,
        descent: CGFloat
    ) -> NSMutableAttributedString {
        // TODO: -
        .init(string: "")
    }
}

// MARK: - NSMutableAttributedString
extension SYYable where Base: NSMutableAttributedString {

}

extension NSAttributedString.Key: SYYCompatible {}
extension SYYable where Base == NSAttributedString.Key {
    static let shadow = Base("com.swiftytext.attribute.shadow")
    static let innerShadow = Base("com.swiftytext.attribute.innershadow")
    static let underline = Base("com.swiftytext.attribute.underline")
    static let strikethrough = Base("com.swiftytext.attribute.strikethrough")
    static let border = Base("com.swiftytext.attribute.border")
    static let backgroundBorder = Base("com.swiftytext.attribute.backgroundborder")
    static let glyphTransform = Base("com.swiftytext.attribute.glyphtransform")
    static let backedString = Base("com.swiftytext.attribute.backedString")
}
