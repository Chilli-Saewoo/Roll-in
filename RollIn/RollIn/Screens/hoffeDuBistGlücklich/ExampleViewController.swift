//
//  ExampleViewController.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/21.
//


/// HoffeDuBistGlücklich이라는 화면을, ViewController와 여러개의 View들이 구성하고 있습니다.
/// 물론 필요하면 VC가 여러개가 되어도 되겠죠??
///
import UIKit

class ExampleViewController: UIViewController {
    
    let viewOne = SomeOneView(frame: .zero)
    let viewTwo = SomeTwoView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(viewOne)
        view.addSubview(viewTwo)
    }


}

