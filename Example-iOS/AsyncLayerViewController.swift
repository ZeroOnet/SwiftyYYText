//
//  AsyncLayerViewController.swift
//  Example-iOS
//
//  Created by 李文康 on 2024/7/5.
//  Copyright © 2024 Shanbay iOS. All rights reserved.
//

import UIKit
@testable import SwiftyYYText

final class AsyncLayerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.layer.addSublayer(_asyncLayer)
        SYY.Transaction.commit(self, selector: #selector(_update))
    }

    @objc
    private func _update() {
        // Important: Marks the layer’s contents as needing to be updated.
        _asyncLayer.setNeedsDisplay()
    }

    private lazy var _asyncLayer: CALayer = {
        let result = SYY.AsyncLayer()
        result.cornerRadius = 8
        result.backgroundColor = UIColor.red.cgColor
        result.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        result.delegate = self
        return result
    }()
}

extension AsyncLayerViewController: SYYAsyncLayerDelegate, CALayerDelegate {
    var task: any SYYAsyncLayerTaskable {
        SYY.DefaultAsyncLayerTask().onDisplay { context, size, isCancelled in
            guard isCancelled() == false else { return }
            UIColor.green.setFill()
            context.fill(CGRect(origin: .zero, size: CGSize(width: 50, height: 50)))
        }
    }
}
