//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

struct GraphUtil {
	
	private static func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
		return sqrt(pow(point1.x-point2.x, 2)+pow(point1.y-point2.y, 2))
	}
	
	static func nearestDefinedPointIndices(touchedPoint: CGPoint, definedPoints: [[UIBezierPath]], centerPoint: CGPoint) -> (dimension: Int, score: Int) {
		var shortestDistance: CGFloat = 0
		var dimensionIndex: Int = 0
		var scoreIndex: Int = 0
		for dimension in definedPoints {
			for score in dimension {
				if shortestDistance != 0 {
					let distance = distanceBetweenPoints(score.currentPoint, point2: touchedPoint)
					if distance < shortestDistance {
						shortestDistance = distance
						dimensionIndex = definedPoints.indexOf({$0 == dimension})!
						scoreIndex = dimension.indexOf(score)!
					}
				} else {
					shortestDistance = distanceBetweenPoints(score.currentPoint, point2: touchedPoint)
				}
			}
		}
		if shortestDistance > distanceBetweenPoints(touchedPoint, point2: centerPoint) {
			return (dimensionIndex, -1)
		}
		return (dimensionIndex, scoreIndex)
	}
	
}

class InteractiveGraphView: UIView {
	
    /// Dimensions
    var dimensions: [String]!
	
	/// Max score allowed
	var maxScore: Int!
	
	/// Selected score
	var selectedScore: [Int]!
	
	/// Two-dimensional array that stores interactive points
	private var definedPoints: [[UIBezierPath]] = []
	
	/// The radius of the smallest circle
	private var innerCircleRadius: CGFloat!
	
	/// Frame center point
	private var centerPoint: CGPoint!
	
	init(origin: CGPoint,
	     sideLength: CGFloat,
	     dimensions: [String] = ["回味", "苦", "干", "黏", "冷", "酸", "湿", "涩"],
	     maxScore: Int = 5,
	     selectedScore: [Int] = []) {
		super.init(frame: CGRectMake(origin.x, origin.y, sideLength, sideLength))
		
		// Property setup
		self.dimensions = dimensions
		self.maxScore = maxScore
		centerPoint = CGPointMake(frame.size.height/2, frame.size.width/2)
		innerCircleRadius = sideLength*0.4/CGFloat(maxScore)
		if selectedScore.isEmpty {
			self.selectedScore = [Int](count: dimensions.count, repeatedValue: 0)
		} else {
			if selectedScore.count != dimensions.count {
				assertionFailure("Selected score count should correspond to dimension count!")
			} else {
				self.selectedScore = selectedScore
			}
		}
		
		// View setup
		backgroundColor = UIColor.whiteColor()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}
	
    override func drawRect(rect: CGRect) {
		let piSegment = 2.0*M_PI/Double(dimensions.count)
		UIColor.blackColor().setFill()
		UIColor.blackColor().setStroke()
		
		// Draw the underlying graph & Fill in definedPoint array
		for i in 0..<dimensions.count {
			let degree = piSegment*Double(i)
			var scorePoints: [UIBezierPath] = []
			for j in 0...maxScore {
				let radius = j != maxScore ? (CGFloat(j)+1)*innerCircleRadius : (CGFloat(j)+0.5)*innerCircleRadius
				let x = radius*CGFloat(cos(degree))
				let y = radius*CGFloat(sin(degree))
				let point = CGPointMake(centerPoint.x+x, centerPoint.y+y)
				
				if j != maxScore {
					// Draw selection circle and connecting lines
					let selectionCircle = UIBezierPath(arcCenter: point, radius: 5, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
					selectionCircle.lineWidth = 2
					selectionCircle.stroke()
					scorePoints.append(selectionCircle)
					if j == maxScore-1 {
						let connectingLine = UIBezierPath()
						connectingLine.lineWidth = 2
						connectingLine.moveToPoint(centerPoint)
						connectingLine.addLineToPoint(point)
						connectingLine.stroke()
					}
					
					// Draw connecting circle
					if i == dimensions.count-1 {
						let connectingCircle = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
						connectingCircle.lineWidth = 2
						connectingCircle.stroke()
					}
				} else {
					// Add dimension name label
					let label = UILabel(frame: CGRectMake(point.x-30, point.y-10, 60, 20))
					label.textAlignment = .Center
					label.font = UIFont.boldSystemFontOfSize(25.0)
					label.text = dimensions[i]
					self.addSubview(label)
				}
			}
			definedPoints.append(scorePoints)
		}
		
		// Hollow the selection circle
		UIColor.whiteColor().setFill()
		for dimension in definedPoints {
			for selectionPoint in dimension {
				selectionPoint.fill()
			}
		}
    }
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touchPoint = touches.first?.locationInView(self)
		let nearestIndices = GraphUtil.nearestDefinedPointIndices(touchPoint!, definedPoints: definedPoints, centerPoint: centerPoint)
		selectedScore[nearestIndices.dimension] = nearestIndices.score+1
		print(selectedScore)
	}
    
}

XCPlaygroundPage.currentPage.liveView = InteractiveGraphView(origin: CGPointZero, sideLength: 800)
