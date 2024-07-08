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

        let layer = SYY.AsyncLayer()
        layer.cornerRadius = 8
        layer.backgroundColor = UIColor.red.cgColor
        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        // Important: Marks the layer’s contents as needing to be updated.
        layer.setNeedsDisplay()
        layer.delegate = self
        view.layer.addSublayer(layer)
    }
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
