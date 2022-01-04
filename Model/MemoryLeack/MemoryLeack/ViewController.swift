//
//  ViewController.swift
//  MemoryLeack
//
//  Created by 황신택 on 2021/11/22.
//

import UIKit

class ViewController: UIViewController {

    var a = 0
    
    lazy var block = {
        print(self.a)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        block()
        print(#function, self)
    }
    
    deinit {
        print(#function, self)
    }
}

