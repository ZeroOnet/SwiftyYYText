//
//  SYYTextView.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

/// The SYYTextViewDelegate protocol defines a set of optional methods you can use to receive editing-related messages for SYYTextView objects.
public protocol SYYTextViewDelegate: AnyObject {}

@IBDesignable
public final class SYYTextView: UIScrollView {
    /// The text displayed by the text view.
    /// - Default value is nil.
    /// - Set a new value to this property also replaces the text in ``attributedText``.
    /// - Get the value returns the plain text in ``attributedText``.
    @IBInspectable public var text: String?

    /// The font of the text.
    /// - Default value is 12-point system font.
    /// - Set a new value to this property also causes the new font to be applied to the entire ``attributedText``.
    /// - Get the value returns the font at the head of ``attributedText``.
    @IBInspectable public var font: UIFont = .systemFont(ofSize: 12)

    /// The color of the text.
    /// - Default value is UIColor.black.
    /// - Set a new value to this property also causes the new color to be applied to the entire ``attributedText``.
    /// - Get the value returns the color at the head of ``attributedText``.
    @IBInspectable public var textColor = UIColor.black

    /// The styled text that the text view displays.
    /// - Set a new value to this property also replaces the value of the `text`, `font`, `textColor`,
    ///   `textAlignment` and other properties in label.
    @IBInspectable public var attributedText: NSAttributedString?

    /// The placeholder text displayed by the text view (when the text view is empty).
    /// - Set a new value to this property also replaces the text in ``placeholderAttributedText``.
    /// - Get the value returns the plain text in ``placeholderAttributedText``.
    @IBInspectable public var placeholderText: String?

    /// The font of the placeholder text. Default is same as `font` property.
    /// - Set a new value to this property also causes the new font to be applied to the entire ``placeholderAttributedText``.
    /// - Get the value returns the font at the head of ``placeholderAttributedText``.
    @IBInspectable public var placeholderFont: UIFont = .systemFont(ofSize: 12)

    /// The color of the placeholder text. Default is gray.
    /// - Set a new value to this property also causes the new color to be applied to the entire ``placeholderAttributedText``.
    /// - Get the value returns the color at the head of ``placeholderAttributedText``.
    @IBInspectable public var placeholderTextColor: UIColor = .gray

    /// The styled placeholder text displayed by the text view (when the text view is empty).
    /// - Set a new value to this property also replaces the value of the ``placeholderText``, ``placeholderFont``, ``placeholderTextColor``.
    @IBInspectable public var placeholderAttributedText: NSAttributedString?

    ///  The inset of the text container's layout area within the text view's content area.
    @IBInspectable public var textContainerInset: UIEdgeInsets = .init(top: 6, left: 4, bottom: 6, right: 4)

    /// The technique to use for aligning the text.
    /// - Default value is NSTextAlignment.natural.
    /// - Set a new value to this property also causes the new alignment to be applied to the entire ``attributedText``.
    /// - Get the value returns the alignment at the head of ``attributedText``.
    @IBInspectable public var textAlignment: NSTextAlignment = .natural

    /// The text vertical aligmnent in container.
    /// - Default is .top.
    @IBInspectable public var textVerticalAlignment: SYY.TextVerticalAlignment = .top

    /// A Boolean value indicating whether the receiver's layout orientation is vertical form.
    /// - Default value is false. It may used to display CJK text.
    @IBInspectable public var isVerticalForm = false

    /// A Boolean value indicating whether inserting text replaces the previous contents.
    /// - Default value is false.
    @IBInspectable public var clearsOnInsertion = false

    /// The current selection range of the text view.
    @IBInspectable public var selectedRange: NSRange = NSRange(location: 0, length: 0)

    /// A Boolean value that indicates whether the text view is selectable.
    /// - This property controls the ability of the user to select content and interact with URLs and text attachments. The default value is true.
    @IBInspectable public var isSelectable: Bool = true

    /// A Boolean value indicating whether the receiver is highlightable.
    /// - When the value of this property is false, user cannot interact with the highlight range of text. Default is true.
    @IBInspectable public var isHighlightable: Bool = true

    /// A Boolean value that indicates whether the text view is editable.
    /// - When the value of this property is false, user cannot edit text. Default is true.
    @IBInspectable public var isEditable: Bool = true

    /// A Boolean value indicating whether the receiver can paste image from pasteboard.
    /// - When the value of this property is true, user can paste image from pasteboard via "paste" menu. Default is false.
    @IBInspectable public var allowsPasteImage: Bool = false

    /// A Boolean value indicating whether the receiver can paste attributed text from pasteboard.
    /// - When the value of this property is true, user can paste attributed text from pasteboard via "paste" menu. Default is false.
    @IBInspectable public var allowsPasteAttributedString: Bool = false

    /// A Boolean value indicating whether the receiver can copy attributed text to pasteboard.
    /// - When the value of this property is true, user can copy attributed text (with attachment image) from text view to pasteboard via "copy" menu. Default is true.
    @IBInspectable public var allowsCopyAttributedString: Bool = true

    /// A Boolean value indicating whether the receiver can undo and redo typing with shake gesture.
    /// Default value is true.
    @IBInspectable public var allowsUndoAndRedo: Bool = true

    /// The maximum undo/redo level.
    /// - Default value is 20.
    @IBInspectable public var maximumUndoLevel: UInt = 20

    /// If you use an custom accessory view without ``inputAccessoryView`` property, you may set the accessory view's height. It may used by auto scroll calculation.
    @IBInspectable public var extraAccessoryViewHeight: CGFloat = 0

    /// An array of UIBezierPath objects representing the exclusion paths inside the
    /// receiver's bounding rectangle.
    /// - Default value is nil.
    public var exclusionPaths: [UIBezierPath]?

    /// The types of data that convert to tappable URLs in the text view.
    /// - Default is .none.
    public var dataDetectorTypes: UIDataDetectorTypes = []

    /// The attributes to apply to links at normal state.
    /// - When a range of text is detected by the `dataDetectorTypes`, this value would be used to modify the original attributes in the range.
    public var linkTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.systemBlue
    ]

    /// The attributes to apply to links at highlight state.
    /// - When a range of text is detected by the `dataDetectorTypes` and the range was touched by user, this value would be used to modify the original attributes in the range.
    public var highlightTextAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.gray
    ]

    /// The attributes to apply to new text being entered by the user.
    /// - When the text view's selection changes, this value is reset automatically.
    public var typingAttributes: [NSAttributedString.Key: Any] = [:]

    /// The delegate of text.
    public weak var textDelegate: (any SYYTextViewDelegate)?

    /// When ``text`` or ``attributedText`` is changed, the parser will be called to modify the text.
    /// - Default value is nil.
    public var textParser: SYYTextParsable?

    /// The current text layout in text view. It can be used to query the text layout information.
    /// - Set a new value to this property also replaces most properties in this label.
    ///   Such as `text`, `color`, `attributedText`, `lineBreakMode`, `textContainerPath`, `exclusionPaths` and so on.
    public var textLayout: SYYTextLayoutType?

    /// The debug option to display CoreText layout result.
    public var debugOption: SYY.TextDebugOption?

    /// The text line position modifier used to modify the lines' position in layout.
    /// - Default value is nil.
    public var linePositionModifier: SYYTextLinePositionModifiable?
}

extension SYYTextView {
    /// Scrolls the receiver until the text in the specified range is visible.
    /// - Parameter range: The range of text to scroll into view.
    public func scrollRangeToVisible(_ range: NSRange) {

    }
}
