//
//  SYYLabel.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/5/14.
//

@IBDesignable
public final class SYYLabel: UIView {
    public override class var layerClass: AnyClass { SYY.AsyncLayer.self }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _init()
    }
    
    /// The text displayed by the label.
    /// - Default value is nil.
    /// - Set a new value to this property also replaces the text in ``attributedText``.
    /// - Get the value returns the plain text in ``attributedText``.
    @IBInspectable public var text: String?

    /// The styled text that the label displays.
    /// - Set a new value to this property also replaces the value of the `text`, `font`, `textColor`,
    ///   `textAlignment` and other properties in label.
    @IBInspectable public var attributedText: NSAttributedString?

    /// The color of the text. 
    /// - Default value is UIColor.label.
    /// - Set a new value to this property also causes the new color to be applied to the entire ``attributedText``.
    /// - Get the value returns the color at the head of ``attributedText``.
    @IBInspectable public var textColor = UIColor.label

    /// The technique to use for aligning the text. 
    /// - Default value is NSTextAlignment.natural.
    /// - Set a new value to this property also causes the new alignment to be applied to the entire ``attributedText``.
    /// - Get the value returns the alignment at the head of ``attributedText``.
    @IBInspectable public var textAlignment: NSTextAlignment = .natural

    /// The text vertical aligmnent in container.
    /// - Default is .center.
    @IBInspectable public var textVerticalAlignment: SYY.TextVerticalAlignment = .center

    /// The font of the text. 
    /// - Default value is 17-point system font.
    /// - Set a new value to this property also causes the new font to be applied to the entire ``attributedText``.
    /// - Get the value returns the font at the head of ``attributedText``.
    @IBInspectable public var font: UIFont = .systemFont(ofSize: 17)

    /// The shadow color of the text.
    /// - Default value is nil.
    /// - Set a new value to this property also causes the shadow color to be applied to the entire ``attributedText``.
    /// - Get the value returns the shadow color at the head of ``attributedText``.
    @IBInspectable public var shadowColor: UIColor?

    /// The shadow offset of the text. 
    /// - Default value is CGSizeZero.
    /// - Set a new value to this property also causes the shadow offset to be applied to the entire ``attributedText``.
    /// - Get the value returns the shadow offset at the head of ``attributedText``.
    @IBInspectable public var shadowOffset: CGSize = .zero

    /// The shadow blur of the text.
    /// - Default value is 0.
    /// - Set a new value to this property also causes the shadow blur to be applied to the entire ``attributedText``.
    /// - Get the value returns the shadow blur at the head of ``attributedText``.
    @IBInspectable public var shadowBlurRadius: CGFloat = .zero

    /// The technique for wrapping and truncating the label’s text.
    /// - The default value of this property is NSLineBreakMode.byTruncatingTail.
    @IBInspectable public var lineBreakMode: NSLineBreakMode = .byTruncatingTail

    /// The truncation token string used when text is truncated.
    /// - Default value is nil. When the value is nil, the label use "…" as default truncation token.
    @IBInspectable public var truncationToken: NSAttributedString?

    /// The maximum number of lines for rendering text.
    /// - The default value for this property is 1. To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.
    @IBInspectable public var numberOfLines: Int = 1

    /// A Boolean value indicating whether the receiver's layout orientation is vertical form.
    /// - Default value is false. It may used to display CJK text.
    @IBInspectable public var isVerticalForm = false

    /// A Boolean value indicating whether the layout and rendering codes are running
    /// asynchronously on background threads.
    /// - Default value is false.
    @IBInspectable public var isAsynchronous = false

    /// A Boolean value indicating whether clean layer's content before display asynchronously.
    /// - Default value is true.
    @IBInspectable public var isCanvasClean = true

    /// A Boolean value indicating whether change layer content with a fade animation.
    /// - Default value is true.
    @IBInspectable public var isDisplayAnimated = true

    /// A Boolean value indicating whether text become highlighted with a fade animation.
    /// - Default value is true.
    @IBInspectable public var isHighlightAnimated = true

    /// A Boolean value indicating whether ignore properties(text, font......) and only use ``textLayout`` to render content.
    /// - Default value is false.
    @IBInspectable public var isLayoutEnabledOnly = false

    /// The inset of the text container's layout area within the text view's content area.
    /// - Default value is UIEdgeInsets.Zero.
    @IBInspectable public var textContainerInset: UIEdgeInsets = .zero

    /// A UIBezierPath object that specifies the shape of the text frame.
    /// - Default value is nil.
    public var textContainerPath: UIBezierPath?

    /// An array of UIBezierPath objects representing the exclusion paths inside the
    /// receiver's bounding rectangle.
    /// - Default value is nil.
    public var exclusionPaths: [UIBezierPath]?

    /// The preferred maximum width for a multiline label.
    /// - This property affects the size of the label when layout constraints
    /// are applied to it. During layout, if the text extends beyond the width
    /// specified by this property, the additional text is flowed to one or more new
    /// lines, thereby increasing the height of the label. If the text is vertical
    /// form, this value will match to text height.
    /// - Default value is 0, which means using the container’s width.
    public var preferredMaxLayoutWidth: CGFloat = 0

    /// The text line position modifier used to modify the lines' position in layout.
    /// - Default value is nil.
    public var linePositionModifier: SYYTextLinePositionModifiable?

    /// The debug option to display CoreText layout result.
    public var debugOption: SYY.TextDebugOption?

    /// When ``text`` or ``attributedText`` is changed, the parser will be called to modify the text.
    /// - Default value is nil.
    public var textParser: SYYTextParsable?

    /// The current text layout in text view. It can be used to query the text layout information.
    /// - Set a new value to this property also replaces most properties in this label.
    ///   Such as `text`, `color`, `attributedText`, `lineBreakMode`, `textContainerPath`, `exclusionPaths` and so on.
    public var textLayout: SYYTextLayoutable?
}

extension SYYLabel {
    private func _init() {
        contentMode = .redraw
        isAccessibilityElement = true
    }
}
