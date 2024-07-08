//
//  SYY+AsyncLayer.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/4.
//

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

        override func display() { 
            // https://github.com/ibireme/YYAsyncLayer/issues/18
            // Assigning a value to this property causes the layer to use your image rather than create a separate backing store.
            // Don't listen to our subclasses crazy ideas about setContents by going through super
            super.contents = super.contents;
            _display()
        }

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
        let task = (delegate as? SYYAsyncLayerDelegate)?.task
        task?.willDisplay?(self)
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
            task?.didDisplay?(self, true)
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
                    context.fill(.init(origin: .zero, size: size))
                    task?.display?(context, size, isCancelled)
                }
            DispatchQueue.main.async {
                if isCancelled() { task?.didDisplay?(self, false); return }
                self.contents = image.cgImage
                task?.didDisplay?(self, true)
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
