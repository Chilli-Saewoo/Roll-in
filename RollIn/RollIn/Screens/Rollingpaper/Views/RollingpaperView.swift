//
//  RollingpaperView.swift
//  RollIn
//
//  Created by Noah Park on 2022/10/25.
//

import UIKit

protocol RollingpaperViewDelegate: AnyObject {
    func handleOpacityValue(newVal: Float)
}


final class RollingpaperView: UIView {
    //기기의 화면 크기
    private let viewWidth: CGFloat = UIScreen.main.bounds.width
    private let viewHeight: CGFloat = UIScreen.main.bounds.height
    //핀치줌 최댓값, 최솟값,
    private var recognizerScale: CGFloat = 1.0
    private var maxScale: CGFloat { 3.0 * CGFloat(noteSizeProportion) }
    private var minScale: CGFloat = 1.0
    var noteSizeProportion: CGFloat = 1
    
    weak var delegate: RollingpaperViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .CustomBackgroundColor
        addGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_ :)))
        self.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDrag))
        self.addGestureRecognizer(panGesture)
        
    }
    //https://zeddios.tistory.com/343
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if (gesture.state == .began || gesture.state == .changed) {
            if(recognizerScale < maxScale && gesture.scale > 1.0) {
                self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                if let delegate = delegate {
                    delegate.handleOpacityValue(newVal: Float((2 * CGFloat(noteSizeProportion)) - recognizerScale))
                }
                recognizerScale *= gesture.scale
                scaleView(view: self, scale: recognizerScale)
                scaleLayer(layer: self.layer, scale: recognizerScale)
                gesture.scale = 1.0
            }
            else if (recognizerScale > minScale && gesture.scale < 1.0) {
                self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                if let delegate = delegate {
                    delegate.handleOpacityValue(newVal: Float((2 * CGFloat(noteSizeProportion)) - recognizerScale))
                }
                recognizerScale *= gesture.scale
                scaleView(view: self, scale: recognizerScale)
                scaleLayer(layer: self.layer, scale: recognizerScale)
                gesture.scale = 1.0
            }
            if recognizerScale < 1.0 {
                let setVal = 1.0 / self.recognizerScale
                self.transform = self.transform.scaledBy(x: setVal, y: setVal)
                self.recognizerScale *= setVal
                self.relocateView()
            } else {
                relocateView()
            }
        }
    }
    
    func relocateView() {
        if (self.frame.origin.x > 0) {
            self.frame.origin.x = 0
        }
        if (self.frame.origin.x + self.frame.width < viewWidth) {
            self.frame.origin.x = viewWidth - self.frame.width
        }
        if (self.frame.origin.y > 0) {
            self.frame.origin.y = 0
        }
        if (self.frame.origin.y + self.frame.height < viewHeight) {
            self.frame.origin.y = viewHeight - self.frame.height
        }
    }
    
    //https://hyowonee.github.io/22-44-iOS-viewDrag.html
    @objc private func didDrag(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        if (sender.view!.frame.width > viewWidth && sender.view!.frame.height > viewHeight) {
            sender.view!.center = CGPoint(x: sender.view!.center.x + (translation.x * recognizerScale), y: sender.view!.center.y + (translation.y * recognizerScale))
            sender.setTranslation(.zero, in: self)
        }
        if(sender.view!.frame.origin.x > 0.0) {
            self.frame.origin.x = 0.0
        } else if(viewWidth - (self.frame.width + self.frame.origin.x) > 0.0) {
            self.frame.origin.x += (viewWidth - (self.frame.width + self.frame.origin.x))
        }
        if(sender.view!.frame.origin.y > 0.0) {
            self.frame.origin.y = 0.0
        } else if(viewHeight - (self.frame.height + self.frame.origin.y) > 0.0) {
            self.frame.origin.y += (viewHeight - (self.frame.height + self.frame.origin.y))
        }
    }
    
    func scaleView( view: UIView, scale: CGFloat ){
        view.contentScaleFactor = scale
        for vi in view.subviews {
            scaleView(view: vi, scale: scale)
        }
    }

    func scaleLayer( layer: CALayer, scale: CGFloat ){
        layer.contentsScale = scale
        if layer.sublayers == nil {
            return
        }
        for la in layer.sublayers! {
            scaleLayer(layer: la, scale: scale)
        }
    }
}
