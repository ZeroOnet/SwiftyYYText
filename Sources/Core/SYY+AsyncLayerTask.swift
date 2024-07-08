//
//  SYY+AsyncLayerTask.swift
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/8.
//

protocol SYYAsyncLayerTaskable: AnyObject {
    var willDisplay: ((CALayer) -> Void)? { get set }
    var display: ((_ context: UIGraphicsImageRendererContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void)? { get set }
    var didDisplay: ((_ layer: CALayer, _ isFinished: Bool) -> Void)? { get set }
}

extension SYYAsyncLayerTaskable {
    @discardableResult
    func onWillDisplay(_ willDisplay: @escaping (CALayer) -> Void) -> Self {
        self.willDisplay = willDisplay
        return self
    }

    @discardableResult
    func onDisplay(_ display: @escaping (_ context: UIGraphicsImageRendererContext, _ size: CGSize, _ isCancelled: () -> Bool) -> Void) -> Self {
        self.display = display
        return self
    }

    @discardableResult
    func onDidDisplay(_ didDisplay: @escaping (_ layer: CALayer, _ isFinished: Bool) -> Void) -> Self {
        self.didDisplay = didDisplay
        return self
    }
}

protocol SYYAsyncLayerDelegate {
    var task: any SYYAsyncLayerTaskable { get }
}

extension SYY {
    class DefaultAsyncLayerTask: SYYAsyncLayerTaskable {
        var willDisplay: ((CALayer) -> Void)?
        var display: ((UIGraphicsImageRendererContext, CGSize, () -> Bool) -> Void)?
        var didDisplay: ((CALayer, Bool) -> Void)?
    }
}
