//
//  SYY+AsyncLayer.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/4.
//

protocol SYYAsyncLayerDisplayTaskable {
    var willDisplay: ((CALayer) -> Void)? { get set }
    var display: ((_ context: CGContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void)? { get set }
    var didDisplay: ((_ layer: CALayer, _ isFinished: Bool) -> Void)? { get set }
}

extension SYYAsyncLayerDisplayTaskable {
    @discardableResult
    mutating func onWillDisplay(_ willDisplay: @escaping (CALayer) -> Void) -> Self {
        self.willDisplay = willDisplay
        return self
    }

    @discardableResult
    mutating func onDisplay(_ display: @escaping (_ context: CGContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void) -> Self {
        self.display = display
        return self
    }

    @discardableResult
    mutating func onDidDisplay(_ didDisplay: @escaping (_ layer: CALayer, _ isFinished: Bool) -> Void) -> Self {
        self.didDisplay = didDisplay
        return self
    }
}

protocol SYYAsyncLayerDelegate {
    var asyncDisplayTask: SYYAsyncLayerDisplayTaskable { get }
}

extension SYY {
    class AsyncLayer: CALayer {
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
        guard let task = (delegate as? SYYAsyncLayerDelegate)?.asyncDisplayTask else { return }

        if task.display == nil {
            task.willDisplay?(self)
            contents = nil
            task.didDisplay?(self, true)
            return
        }

        task.willDisplay?(self)
        let sentinel = _sentinel
        let value = sentinel.value
        let isCancelled = {
            return sentinel.value != value
        }
        let size = bounds.size
        let isOpaque = isOpaque
        let contentsScale = contentsScale

        if size.syy.isInvalid {
            // 'CFRelease' is unavailable: Core Foundation objects are automatically memory managed
            contents = nil
            task.didDisplay?(self, true)
            return
        }


    }

    private func _cancelAsyncDisplay() {
        _sentinel.increase()
    }
}

extension SYY.AsyncLayer {
    private class _Sentinel {
        private(set) var value = Int32.zero

        @discardableResult
        func increase() -> Int32 { OSAtomicIncrement32(&value) }
    }
}

extension SYY.AsyncLayer {
    private struct _QueueManager {
        static var display: DispatchQueue {
            // TODO: - 能否用位移运算替代模运算
            let idx = Int(OSAtomicIncrement64(&_counter)) % _queueCount
            return _queues[idx]
        }

        private static var _counter = Int64.zero

        // Static members of class or struct are thread-safe for initializing.
        private static let _queueCount: Int = {
            let maxQueueCount = 16
            let apc = ProcessInfo.processInfo.activeProcessorCount
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
