//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var myVariable = 42
myVariable = 50
let myConstant = 42

let implicitDouble = 70.0
let explicitDouble: Double = 70.0

let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples"
let fruitSummary = "I have \(apples + oranges) pieces of fruit."

// Array
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"
shoppingList = []
var occupations = ["Malcolm": "Captain", "Kaylee": "Mechanic"]
occupations["Jayne"] = "Public Relations"
occupations = [:]

// Control Flow
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}
print(teamScore)

// Optional
var optionalString: String? = "Hello"
print(optionalString == nil)

var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}

// Switch
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        print("Add some raisins and makes ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where
        x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:
        print("Everything tastes good in soup")
}

// For in
let interestingNumbers = [
    "Primes": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25]
]
var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)

// While loop
var n = 2
while n < 100 {
    n *= 2
}
print(n)

// Repeat while, runs at least once
var m = 2
repeat {
    m *= 2
} while m < 100
print(m)

// for
var firstForLoop = 0
for i in 0..<4 {
    firstForLoop += i
}
print(firstForLoop)

var secondForLoop = 0
for var i = 0; i < 4; ++i {
    secondForLoop += i
}
print(secondForLoop)

// Functions and closures
func greet(name: String, day: String) -> String {
    return "Hello \(name), today is \(day)."
}
greet("Bob", day: "Tuesday")

// Tuples
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    return(min, max, sum)
}
let statistics = calculateStatistics([5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.2)

func sumOf(numbers: Int...) -> Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}
sumOf(42, 597, 12)

// Nested functions
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

// Function returns a function
func makeIncrementer() -> (Int -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var increment = makeIncrementer()
increment(7)

func hasAnyMatches(list: [Int], condition: Int -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(numbers, condition: lessThanTen)

// Closure
let mappedNumbers = numbers.map({number in 3 * number})
print(mappedNumbers)
let sortedNumbers = numbers.sort{$0 > $1}
print(sortedNumbers)

// Object and Class
class Shape {
    var numbersOfSides = 0
    func simpleDescription() -> String {
        return "A shape with \(numbersOfSides) sides."
    }
    func sayHello(name: String) -> String {
        return "Say hello to \(name)"
    }
}

var shape = Shape()
shape.sayHello("Lisa!")
shape.numbersOfSides = 7
shape.simpleDescription()

class NamedShape {
    var numberOfSides: Int = 0
    var name: String
    init(name: String) {
        self.name = name
    }
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

// Subclass
class Square: NamedShape {
    var sideLength: Double
    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }
    func area() -> Double {
        return sideLength*sideLength
    }
    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}
let testSquare = Square(sideLength: 5.2, name: "my test square")
testSquare.area()
testSquare.simpleDescription()

class Circle: NamedShape {
    var radius: Double
    init(radius: Double, name: String) {
        self.radius = radius
        super.init(name: name)
    }
    func area() -> Double {
        return 3.14 * radius * radius
    }
    override func simpleDescription() -> String {
        return "A circle with radius of \(radius)"
    }
}
let testCircle = Circle(radius: 4.5, name: "My Circle")
testCircle.area()
testCircle.simpleDescription()

class 女朋友 {
    let name = "葛莉莎"
    var 身高: Double
    var 体重: Double
    var gender: String
    var sexualOrientation: String
    let 男朋友 = "黄博康"
    var numberOfChild = 0
    init(height: Double, weight: Double, gender: String, sexualOrientation:String) {
        self.身高 = height
        self.体重 = weight
        self.gender = gender
        self.sexualOrientation = sexualOrientation
    }
    func simpleDescripton() -> String {
        return "\(name)身高\(身高), 体重\(体重), 性别\(gender), 性取向\(sexualOrientation)还有唯一不变的男朋友\(男朋友)"
    }
    func 长个儿() {
        身高+=5
    }
    func 瘦身() {
        体重-=5
    }
    func 生个娃() {
        numberOfChild+=1
    }
}
let lisa = 女朋友(height: 168, weight: 99, gender: "男", sexualOrientation: "Bisexual")
print(lisa.simpleDescripton())
lisa.长个儿()
print(lisa.身高)
lisa.生个娃()
print(lisa.numberOfChild)
