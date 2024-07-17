//
//  SYY+TextLine.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/9.
//

/// A text line object wrapped `CTLineRef`.
typealias SYYTextLineable = SYYTextLineSettable & SYYTextLineGettable

protocol SYYTextLineSettable {
    var index: UInt { get set }
    var row: UInt { get set }
    var position: CGPoint { get set }
    var verticalRotationRanges: [SYY.TextRunGlyphRange] { get set }
}

protocol SYYTextLineGettable {
    var line: CTLine { get }
    var range: NSRange { get }

    /// Bounds = Ascent + Descent
    var bounds: CGRect { get }
    var position: CGPoint { get }
    var ascent: CGFloat { get }
    var descent: CGFloat { get }
    var leading: CGFloat { get }
    var lineWidth: CGFloat { get }
    var trailingWhitespaceWidth: CGFloat { get }

    var isVertical: Bool { get }

    var attachments: [SYY.TextAttachment] { get }
}

extension SYYTextLineGettable {
    /// The shortcut of bounds.size.
    var size: CGSize { bounds.size }
    /// The shortcut of bounds.size.width.
    var width: CGFloat { size.width }
    /// The shortcut of bounds.size.height.
    var height: CGFloat { size.height }
    /// The shortcut of bounds.origin.y.
    var top: CGFloat { bounds.minY }
    /// The shortcut of bounds.origin.y + bounds.size.height.
    var bottom: CGFloat { bounds.maxY }
    /// The shortcut of bounds.origin.x.
    var left: CGFloat { bounds.minX }
    /// The shortcut of bounds.origin.x + bounds.size.width.
    var right: CGFloat { bounds.maxX }
}

protocol SYYTextAttachable {

}

extension CALayer: SYYTextAttachable {

}

extension UIImage: SYYTextAttachable {

}

extension UIView: SYYTextAttachable {

}

extension SYY {
    struct TextAttachment {
        let content: SYYTextAttachable
        let contentMode: UIView.ContentMode
        let contentInsets: UIEdgeInsets

        var frame: CGRect?
        var range: NSRange?
    }
}

extension SYY {
    enum TextRunGlyphDrawMode {
        /// No rotate.
        case horizontal
        /// Rotate vertical for single glyph.
        case verticalRotation
        /// Rotate vertical for single glyph, and move the glyph to a better position,
        /// such as fullwidth punctuation.
        case verticalRotationAndMove
    }

    struct TextRunGlyphRange {
        let glyphRangeInRun: NSRange
        let drawMode: TextRunGlyphDrawMode
    }
}

extension SYY {
    struct TextLine: SYYTextLineable, CustomStringConvertible {
        var index: UInt = 0
        var row: UInt = 0
        var position: CGPoint { didSet { _reloadBounds() } }
        var verticalRotationRanges: [SYY.TextRunGlyphRange] = []

        private(set) var ascent: CGFloat = 0
        private(set) var descent: CGFloat = 0
        private(set) var leading: CGFloat = 0
        private(set) var bounds: CGRect = .zero
        private(set) var attachments: [SYY.TextAttachment] = []

        let line: CTLine
        let lineWidth: CGFloat
        let trailingWhitespaceWidth: CGFloat
        let isVertical: Bool
        let range: NSRange
        // First glyph position for baseline, typically is .zero.
        private var _firstGlyphPosition: CGPoint = .zero
        init(line: CTLine, position: CGPoint, isVertical: Bool) {
            self.line = line
            self.position = position
            self.isVertical = isVertical
            self.lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
            let range = CTLineGetStringRange(line)
            self.range = NSRange(location: range.location, length: range.length)
            self.trailingWhitespaceWidth = CTLineGetTrailingWhitespaceWidth(line)

            if CTLineGetGlyphCount(line) > 0, 
               let firstRun = CFArrayGetValueAtIndex(CTLineGetGlyphRuns(line), 0)?.assumingMemoryBound(to: CTRun.self).pointee {
                CTRunGetPositions(firstRun, CFRange(location: 0, length: 1), &_firstGlyphPosition)
            }
            _reloadBounds()
        }

        var description: String {
            "SYYTextLine -> row: \(row) range: \(range) position: \(position) bounds: \(bounds)"
        }

        private mutating func _reloadBounds() {
            if isVertical {
                bounds = CGRect(x: position.x - descent, y: position.y, width: ascent + descent, height: lineWidth)
                bounds.origin.y += _firstGlyphPosition.x
            } else {
                bounds = CGRect(x: position.x, y: position.y - ascent, width: lineWidth, height: ascent + descent)
                bounds.origin.x += _firstGlyphPosition.x
            }

            attachments = []
            let runs = CTLineGetGlyphRuns(line)
            let runsCount = CFArrayGetCount(runs)
            if runsCount == 0 { return }

            for idx in 0..<runsCount {
                guard let runPtr = CFArrayGetValueAtIndex(runs, idx) else { continue }
                let run = runPtr.assumingMemoryBound(to: CTRun.self).pointee
                let glyphCount = CTRunGetGlyphCount(run)
                if glyphCount == 0 { continue }

                guard
                    let attributes = CTRunGetAttributes(run) as? [NSAttributedString.Key: Any],
                    var attachment = attributes[.syy.attachment] as? SYY.TextAttachment
                else { continue }

                var runPosition = CGPoint.zero
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var leading: CGFloat = 0
                var runWidth: CGFloat = 0
                CTRunGetPositions(run, .init(location: 0, length: 1), &runPosition)
                runWidth = CTRunGetTypographicBounds(run, .init(location: 0, length: 0), &ascent, &descent, &leading)

                let runTypoBounds: CGRect
                if isVertical {
                    swap(&runPosition.x, &runPosition.y)
                    runPosition.y = position.y + runPosition.y
                    runTypoBounds = CGRect(x: position.x + runPosition.x - descent, y: runPosition.y, width: ascent + descent, height: runWidth)
                } else {
                    runPosition.x += position.x
                    runPosition.y = position.y - runPosition.y
                    runTypoBounds = CGRect(x: runPosition.x, y: runPosition.y - ascent, width: runWidth, height: ascent + descent)
                }

                attachment.range = CTRunGetStringRange(run).syy.range
                attachment.frame = runTypoBounds
                attachments.append(attachment)
            }
        }
    }
}
