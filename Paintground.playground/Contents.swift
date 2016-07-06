//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"
class DemoView: UIView {
    
    override func drawRect(rect: CGRect) {
        let centerPoint = CGPointMake(rect.size.height/2, rect.size.width/2)
        for i in 1...5 {
            let path = UIBezierPath(arcCenter: centerPoint, radius: CGFloat(60*i), startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
            path.lineWidth = 5
            UIColor.blackColor().setStroke()
            path.stroke()
        }
    }
    
}

let demoView = DemoView(frame: CGRectMake(0, 0, 800, 800))
demoView.backgroundColor = UIColor.whiteColor()
XCPlaygroundPage.currentPage.liveView = demoView
