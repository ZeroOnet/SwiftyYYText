//
//  SYY+TextRunDelegate.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/17.
//

typealias SYYTextRunDelegable = SYYTextRunDelegateGetter & SYYTextRunDelegateSetter

protocol SYYTextRunDelegateGetter {
    var delegate: CTRunDelegate? { get }
}

protocol SYYTextRunDelegateSetter {
    var ascent: CGFloat { get set }
    var descent: CGFloat { get set }
    var width: CGFloat { get set }
}

extension SYY {
    struct TextRunDelegate: SYYTextRunDelegable {
        var ascent: CGFloat
        var descent: CGFloat
        var width: CGFloat

        var delegate: CTRunDelegate? {
            var mutableSelf = self
            var callbacks = CTRunDelegateCallbacks(
                version: kCTRunDelegateCurrentVersion,
                dealloc: { _ in },
                getAscent: { $0.assumingMemoryBound(to: TextRunDelegate.self).pointee.ascent },
                getDescent: { $0.assumingMemoryBound(to: TextRunDelegate.self).pointee.descent },
                getWidth: { $0.assumingMemoryBound(to: TextRunDelegate.self).pointee.width }
            )
            return CTRunDelegateCreate(&callbacks, &mutableSelf)
        }
    }
}
