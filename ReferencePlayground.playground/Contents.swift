//: Playground - noun: a place where people can play

import UIKit

class Apartment {
    
    var person: Person
    
    let name: String
    
    init(name: String, person: Person) {
        self.name = name
        self.person = person
    }
    
    deinit {
        print("Apartment \(name) destroyed!")
    }
}

class Person {
    
    let name: String
    weak var apartment: Apartment!
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Person \(name) has been eliminated!")
    }
}

var person: Person! = Person(name: "Dima")
var apartment: Apartment! = Apartment(name: "Radisson", person: person)

person.apartment = apartment

person = nil
apartment = nil

class Action {
    
    var actionRef: (() -> Void)!
    var num = 10
    
    func set() {
        actionRef = {
            [unowned self] in
            print(self.num)
        }
    }
    
    deinit {
        print("Action destroyed!")
    }
}

var action: Action! = Action()
action.set()
action.actionRef()
action = nil

