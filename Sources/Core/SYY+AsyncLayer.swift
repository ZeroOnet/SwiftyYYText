//
//  SYY+AsyncLayer.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/4.
//

protocol SYYAsyncLayerObservable: AnyObject {
    var willDisplay: ((CALayer) -> Void)? { get set }
    var display: ((_ context: CGContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void)? { get set }
    var didDisplay: ((_ layer: CALayer, _ isFinished: Bool) -> Void)? { get set }
}

extension SYYAsyncLayerObservable {
    @discardableResult
    func onWillDisplay(_ willDisplay: @escaping (CALayer) -> Void) -> Self {
        self.willDisplay = willDisplay
        return self
    }

    @discardableResult
    func onDisplay(_ display: @escaping (_ context: CGContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void) -> Self {
        self.display = display
        return self
    }

    @discardableResult
    func onDidDisplay(_ didDisplay: @escaping (_ layer: CALayer, _ isFinished: Bool) -> Void) -> Self {
        self.didDisplay = didDisplay
        return self
    }
}

extension SYY {
    class AsyncLayer: CALayer {
        weak var observer: SYYAsyncLayerObservable?

        override init() {
            super.init()
            _init()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            _init()
        }

        deinit { _cancelAsyncDisplay() }

        override func setNeedsDisplay() {
            _cancelAsyncDisplay()
            super.setNeedsDisplay()
        }

        override func display() { _display() }

        private let _sentinel = _Sentinel()
    }
}

extension SYY.AsyncLayer {
    private func _init() {
        contentsScale = UIScreen.main.scale
    }
}

extension SYY.AsyncLayer {
    private func _display() {
        observer?.willDisplay?(self)
        let sentinel = _sentinel
        let value = sentinel.value
        let isCancelled = {
            return sentinel.value != value
        }
        let size = bounds.size
        let isOpaque = isOpaque
        let scale = contentsScale
        let backgroundColor = UIColor(cgColor: backgroundColor ?? UIColor.white.cgColor)

        if size.syy.isInvalid {
            // 'CFRelease' is unavailable: Core Foundation objects are automatically memory managed
            contents = nil
            observer?.didDisplay?(self, true)
            return
        }

        _QueueManager.display.async {
            if isCancelled() { return }
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            format.scale = scale
            let image = UIGraphicsImageRenderer(size: size, format: format)
                .image { context in
                    backgroundColor.setFill()
                    UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
                    self.observer?.display?(context.cgContext, size, isCancelled)
                }
            DispatchQueue.main.async {
                if isCancelled() { self.observer?.didDisplay?(self, false); return }
                self.contents = image.cgImage
                self.observer?.didDisplay?(self, true)
            }
        }
    }

    private func _cancelAsyncDisplay() {
        _sentinel.increase()
    }
}

extension SYY.AsyncLayer {
    private class _Sentinel {
        private(set) var value = UInt64.zero

        @discardableResult
        func increase() -> UInt64 { atomicIncrementOne(&value) }
    }
}

extension SYY.AsyncLayer {
    private struct _QueueManager {
        static var display: DispatchQueue {
            let idx = Int(atomicIncrementOne(&_counter) % _queueCount)
            return _queues[idx]
        }

        private init() {}

        private static var _counter = UInt64.zero

        // Static members of class or struct are thread-safe for initializing.
        private static let _queueCount: UInt64 = {
            let maxQueueCount: UInt64 = 16
            let apc = UInt64(ProcessInfo.processInfo.activeProcessorCount)
            return min(max(1, apc), maxQueueCount)
        }()

        private static let _queues: [DispatchQueue] = {
            var result: [DispatchQueue] = []
            for idx in 0..<_queueCount {
                result.append(.init(label: "com.swiftyyytext.display.\(idx)", qos: .userInitiated))
            }
            return result
        }()
    }
}
