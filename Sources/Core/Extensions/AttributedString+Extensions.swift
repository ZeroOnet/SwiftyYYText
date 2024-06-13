//
//  AttributedString+Extensions.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

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
    func attributes(at location: Int = 0) -> [Base.Key: Any] {
        [:]
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
    
    /// Returns the text alignment of the paragraph of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The text alignment of the paragraph for the character at index.
    func alignment(at location: Int = 0) -> NSTextAlignment {
        paragraphStyle(at: location).alignment
    }

    /// Returns the line break mode of the paragraph of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The line break mode of the paragraph for the character at index.
    func lineBreakMode(at location: Int = 0) -> NSLineBreakMode {
        paragraphStyle(at: location).lineBreakMode
    }

    /// Returns the line spacing of the paragraph of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The line spacing of the paragraph for the character at index.
    func lineSpacing(at location: Int = 0) -> CGFloat {
        paragraphStyle(at: location).lineSpacing
    }

    /// Returns the spacing after the end of paragraph of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The spacing after the end of paragraph for the character at index.
    func paragraphSpacingAfter(at location: Int = 0) -> CGFloat {
        paragraphStyle(at: location).paragraphSpacing
    }

    /// Returns the spacing before the beginning of paragraph of the text.
    /// - Parameter location: The index at which to test for NSAttributedString.Key.paragraphStyle.
    /// - Returns: The spacing before the beginning of paragraph for the character at index.
    func paragraphSpacingBefore(at location: Int = 0) -> CGFloat {
        paragraphStyle(at: location).paragraphSpacingBefore
    }

    // NSParagraphStyle
    // -
    // -
    // -
    // -
    // -
    // - firstLineHeadIndent
    // - headIndent
    // - tailIndent
    // - minimumLineHeight
    // - maximumLineHeight
    // - lineHeightMultiple
    // - baseWritingDirection
    // - hyphenationFactor
    // - defaultTabInterval
    // - tabStops
}

// MARK: - Extended NSAttributedString character attribute by SwiftyText
extension SYYable where Base: NSAttributedString {

}

// MARK: - NSMutableAttributedString
extension SYYable where Base: NSMutableAttributedString {

}

extension SYYable where Base == NSAttributedString.Key {
    static let shadow = "com.swiftytext.attribute.shadow"
    static let innerShadow = "com.swiftytext.attribute.innershadow"
    static let underline = "com.swiftytext.attribute.underline"
    static let strikethrough = "com.swiftytext.attribute.strikethrough"
    static let border = "com.swiftytext.attribute.border"
    static let backgroundBorder = "com.swiftytext.attribute.backgroundborder"
    static let glyphTransform = "com.swiftytext.attribute.glyphtransform"
}
