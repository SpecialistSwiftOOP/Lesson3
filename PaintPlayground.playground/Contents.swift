//: Playground - noun: a place where people can play

import UIKit
import CoreGraphics
import PlaygroundSupport

class Shape {
    
    var firstTapLocation: CGPoint!
    var secondTapLocation: CGPoint!
    
    func draw() {
        
    }
}

class Line : Shape {
    
    override func draw() {
        let path = UIBezierPath()
        #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).setStroke()
        path.move(to: firstTapLocation)
        path.lineWidth = 3
        path.addLine(to: secondTapLocation)
        path.stroke()
    }
    
}

class Circle : Shape {
    
    override func draw() {
        let rect = CGRect(origin: firstTapLocation, size: CGSize(width: secondTapLocation.x - firstTapLocation.x, height: secondTapLocation.y - firstTapLocation.y))
        let path = UIBezierPath(ovalIn: rect)
        #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).setStroke()
        path.lineWidth = 3
        path.stroke()
    }
    
}


class ViewController : UIViewController {
    
    var currentShape: Shape!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    }
    
    func beginDrawing() {
        UIGraphicsBeginImageContext(view.bounds.size)
    }
    
    func endDrawing() {
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.layer.sublayers?.removeAll()
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero, size: view.bounds.size)
        layer.contents = image.cgImage
        view.layer.addSublayer(layer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentShape = Circle()
            currentShape.firstTapLocation = touch.location(in: view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            currentShape.secondTapLocation = touch.location(in: view)
            beginDrawing()
            currentShape.draw()
            endDrawing()
        }
    }
    
}

PlaygroundPage.current.liveView = ViewController()
