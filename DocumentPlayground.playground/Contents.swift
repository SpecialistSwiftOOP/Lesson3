//: Playground - noun: a place where people can play

import UIKit

class RenderContext {
    
    func render(symbol: Character) {
        print(symbol, terminator: "")
    }
    
    func render(string: String) {
        print(string)
    }
}

class DocumentElement {
    
    func draw(context: RenderContext) {
        
    }
    
}

class Symbol : DocumentElement {
    
    enum Style {
        
        case regular
        
        case bold
        
        case italic
        
    }
    
    let value: Character
    let style: Style
    
    init(value: Character, style: Style = .regular) {
        self.value = value
        self.style = style
        super.init()
    }
    
    override func draw(context: RenderContext) {
        context.render(symbol: value)
    }
    
}

class Picture : DocumentElement {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    override func draw(context: RenderContext) {
        context.render(string: url)
    }
}

class Graph : DocumentElement {
    
    let function: (Double) -> Double
    
    init(function: @escaping (Double) -> Double) {
        self.function = function
    }
    
    override func draw(context: RenderContext) {
        var x = 0.0
        let h = 0.1
        
        context.render(string: "Function graph:")
        while x < 1.0 + h / 2 {
            let y = function(x)
            context.render(string: "x: \(x) y: \(y)")
            x += h
        }
    }
    
}

class Document {
    
    var elements = [DocumentElement]()
    let context = RenderContext()
    
    func append(element: DocumentElement) -> Document {
        elements.append(element)
        return self
    }
    
    func draw() {
        for element in elements {
            element.draw(context: context)
        }
    }
}

let document = Document()

document
    .append(element: Symbol(value: "d"))
    .append(element: Picture(url: "~/picture.png"))
    .append(element: Graph() {
        x in
        return sin(x)
    })

document.draw()
