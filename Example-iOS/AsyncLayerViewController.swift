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

        var value: UInt64 = .max
        print(atomicIncrementOne(&value))
//        let layer = SYY.AsyncLayer()
////        layer.backgroundColor = UIColor.red.cgColor
//        layer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        // TODO: 不调用 setNeedsDisplay layer 就不会调用 display？
////        layer.setNeedsDisplay()
//        view.layer.addSublayer(layer)
    }
}
