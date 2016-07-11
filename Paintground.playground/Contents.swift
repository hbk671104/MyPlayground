//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

struct GraphUtil {
	
	private static func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
		return hypot(point1.x-point2.x, point1.y-point2.y)
	}
	
	static func nearestDefinedPointIndices(touchedPoint: CGPoint, definedPoints: [[UIBezierPath]], centerPoint: CGPoint) -> (dimension: Int, score: Int) {
		var shortestDistance: CGFloat = 0
		var dimensionIndex = 0
		var scoreIndex = 0
		for d in 0..<definedPoints.count {
			let dimension = definedPoints[d]
			for s in 0..<dimension.count {
				let point = dimension[s].currentPoint
				if shortestDistance != 0 {
					let distance = distanceBetweenPoints(point, point2: touchedPoint)
					if distance < shortestDistance {
						shortestDistance = distance
						dimensionIndex = d
						scoreIndex = s
					}
				} else {
					shortestDistance = distanceBetweenPoints(point, point2: touchedPoint)
				}
			}
		}
		if shortestDistance > distanceBetweenPoints(touchedPoint, point2: centerPoint) {
			return (dimensionIndex, -1)
		}
		return (dimensionIndex, scoreIndex)
	}
	
	static func nearestDefinedPointScoreOnDimension(touchedPoint: CGPoint, dimension: [UIBezierPath], centerPoint: CGPoint) -> Int {
		var shortestDistance = distanceBetweenPoints(touchedPoint, point2: centerPoint)
		var score = -1
		for d in 0..<dimension.count {
			let distance = distanceBetweenPoints(dimension[d].currentPoint, point2: touchedPoint)
			if distance < shortestDistance {
				shortestDistance = distance
				score = d
			}
		}
		return score
	}
	
}

class InteractiveView: InteractiveGraphView {
	
	/// Selected score
	var selectedScores: [Int]!
	
	/// Selected path
	private var selectedPath: [PathCombo]!
	
	/// Lastest selected indices
	private var latestSelectedIndices: (dimension: Int, score: Int)!
	
	/// Path Combo
	private struct PathCombo {
		/// Left conneting path
		var marginPath: UIBezierPath?
		var selectedCircle: UIBezierPath!
		var centerPath: UIBezierPath!
	}
	
	init(frame: CGRect, selectedScores: [Int]) {
		super.init(frame: frame)
		// Custom init
		self.selectedScores = selectedScores
		
		// View setup
		backgroundColor = UIColor.clearColor()
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("This class does not support NSCoding")
	}
	
	override func drawRect(rect: CGRect) {
		UIColor.orangeColor().colorWithAlphaComponent(0.75).setStroke()
		
		// Convert
		selectedPath = self.convertIntoSelectedPath(selectedScores, definedPoints: definedPoints)
		// Draw selected path
		for combo in selectedPath {
			if combo.centerPath != nil {
				combo.centerPath.stroke()
			}
		}
		for combo in selectedPath {
			if combo.selectedCircle != nil {
				combo.selectedCircle.fill()
			}
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touchPoint = touches.first?.locationInView(self)
		let nearestIndices = GraphUtil.nearestDefinedPointIndices(touchPoint!, definedPoints: definedPoints, centerPoint: center)
		// Pass in lastestSelectedIndices
		latestSelectedIndices = nearestIndices
		selectedScores[latestSelectedIndices.dimension] = latestSelectedIndices.score+1
		setNeedsDisplay()
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let touchPoint = touches.first?.locationInView(self)
		let scoreIndex = GraphUtil.nearestDefinedPointScoreOnDimension(touchPoint!, dimension: definedPoints[latestSelectedIndices.dimension], centerPoint: center)
		// Update latest selected index
		latestSelectedIndices = (latestSelectedIndices.dimension, scoreIndex)
		selectedScores[latestSelectedIndices.dimension] = latestSelectedIndices.score+1
		setNeedsDisplay()
	}
	
	private func convertIntoSelectedPath(selectedScores: [Int], definedPoints: [[UIBezierPath]]) -> [PathCombo] {
		var pathCombo: [PathCombo] = []
		for i in 0..<selectedScores.count {
			var combo = PathCombo()
			let score = selectedScores[i]
			if score >= 1 {
				let selectedPoint = definedPoints[i][score-1].currentPoint
				// TODO: There's been a tiny right shift on x-axis, which is confusing, seriously
				let actualPoint = CGPointMake(selectedPoint.x-5, selectedPoint.y)
				// Connected path
				let centerPath = UIBezierPath()
				centerPath.lineWidth = 8
				centerPath.moveToPoint(actualPoint)
				centerPath.addLineToPoint(center)
				// Selected circle
				let selectedCircle = UIBezierPath(arcCenter: actualPoint, radius: 10, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
				selectedCircle.lineWidth = 2
				
				combo.centerPath = centerPath
				combo.selectedCircle = selectedCircle
			}
			pathCombo.append(combo)
		}
		return pathCombo
	}
	
}

class InteractiveGraphView: UIView {
	
    /// Dimensions
    var dimensions: [String]!
	
	/// Max score allowed
	var maxScore: Int!
	
	/// Two-dimensional array that stores interactive points
	private var definedPoints: [[UIBezierPath]] = []
	
	/// The radius of the smallest circle
	private var innerCircleRadius: CGFloat!
	
	/// Interactive view
	private var interactiveView: InteractiveView!
	
	init(origin: CGPoint,
	     sideLength: CGFloat,
	     dimensions: [String] = ["回味", "苦", "干", "黏", "冷", "酸", "湿", "涩"],
	     maxScore: Int = 5,
	     selectedScores: [Int] = []) {
		super.init(frame: CGRectMake(origin.x, origin.y, sideLength, sideLength))
		
		// Property setup
		self.dimensions = dimensions
		self.maxScore = maxScore
		innerCircleRadius = sideLength*0.4/CGFloat(maxScore)
		// Selected score init
		var scores: [Int]!
		if selectedScores.isEmpty {
			scores = [Int](count: dimensions.count, repeatedValue: 0)
		} else {
			if selectedScores.count != dimensions.count {
				assertionFailure("Selected score count should correspond to dimension count!")
			} else {
				scores = selectedScores
			}
		}
		
		// View setup
		backgroundColor = UIColor.whiteColor()
		interactiveView = InteractiveView(frame: self.bounds, selectedScores: scores)
		interactiveView.userInteractionEnabled = true
		self.addSubview(interactiveView)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
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
				let point = CGPointMake(center.x+x, center.y+y)
				
				if j != maxScore {
					// Draw selection circle and connecting lines
					let selectionCircle = UIBezierPath(arcCenter: point, radius: 5, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
					selectionCircle.lineWidth = 2
					selectionCircle.stroke()
					scorePoints.append(selectionCircle)
					if j == maxScore-1 {
						let connectingLine = UIBezierPath()
						connectingLine.lineWidth = 2
						connectingLine.moveToPoint(center)
						connectingLine.addLineToPoint(point)
						connectingLine.stroke()
					}
					
					// Draw connecting circle
					if i == dimensions.count-1 {
						let connectingCircle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
						connectingCircle.lineWidth = 2
						connectingCircle.stroke()
					}
				} else {
					// Add dimension name label
					let label = UILabel(frame: CGRectMake(point.x-30, point.y-10, 60, 20))
					label.textAlignment = .Center
					label.font = UIFont.systemFontOfSize(25.0)
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
		
		// Pass in defined points
		if interactiveView.definedPoints.isEmpty {
			interactiveView.definedPoints = definedPoints
		}
    }
	
}

XCPlaygroundPage.currentPage.liveView = InteractiveGraphView(origin: CGPointZero, sideLength: 800, selectedScores: [2, 2, 3, 4, 2, 1, 3, 3])
