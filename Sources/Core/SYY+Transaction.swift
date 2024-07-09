//
//  SYY+Transaction.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/8.
//

extension SYY {
    struct Transaction {
        typealias Target = AnyObject

        private static var _seeds: Set<_Seed> = {
            let observer = CFRunLoopObserverCreateWithHandler(
                kCFAllocatorDefault,
                CFRunLoopActivity.beforeWaiting.rawValue | CFRunLoopActivity.exit.rawValue,
                true,
                0xFFFFFF // after CATransaction(2000000)
            ) { _, _ in
                for seed in _seeds {
                    _ = seed.target.perform(seed.selector)
                }
                _seeds = []
            }
            CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
            return []
        }()
    }
}

extension SYY.Transaction {
    static func commit(_ target: Target, selector: Selector) {
        _seeds.insert(_Seed(target: target, selector: selector))
    }
}

extension SYY.Transaction {
    private struct _Seed: Hashable {
        let target: Target
        let selector: Selector

        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.target === rhs.target && lhs.selector == rhs.selector
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(target.hash)
            hasher.combine(selector.hashValue)
        }
    }
}
