//: Playground - noun: a place where people can play

import UIKit

class Data {
    
    enum InfoType {
        
        case Control
        
        case Data(key: String)
        
    }
    
    let dataType: InfoType
    
    init(type: InfoType) {
        dataType = type
    }
}

class IntData : Data {
    
    let value: Int
    
    init(value: Int, key: String) {
        self.value = value
        super.init(type: .Data(key: key))
    }
    
}

class StringData : Data {
    
    let value: String
    
    init(value: String, key: String) {
        self.value = value
        super.init(type: .Data(key: key))
    }
}

class Subscriber {
    
    func receive(data: Data) {
        
    }
    
    var supportedData: [Data.InfoType] {
        return []
    }
}

class EventBus {
    
    enum Errors : Error {
        
        case unsupportedSubscriber
        
        case dispatchFailed
        
        case subscriberAlreadyExists
        
        case subscriberNotRegistered
        
    }
    
    var subscribers = [Subscriber]()
    
    func register(subscriber: Subscriber) throws {
        
        guard subscriber.supportedData.count > 0 else {
            throw Errors.unsupportedSubscriber
        }
        
        for registered in subscribers {
            if registered === subscriber {
                throw Errors.subscriberAlreadyExists
            }
        }
        
        subscribers.append(subscriber)
    }
    
    func unregister(subscriber: Subscriber) throws {
        
        var subscriberExists = false
        
        for i in 0..<subscribers.count {
            if subscribers[i] === subscriber {
                subscribers.remove(at: i)
                subscriberExists = true
                break
            }
        }
        
        if !subscriberExists {
            throw Errors.subscriberNotRegistered
        }
    }
    
    func post(data: Data) throws {
        
        var dispatched = false
        let dispatch = { (subscriber: Subscriber) in
            subscriber.receive(data: data)
            dispatched = true
        }
        
        for subscriber in subscribers {
            for supported in subscriber.supportedData {
                switch (data.dataType, supported) {
                case (.Control, .Control):
                    dispatch(subscriber)
                case let (.Data(valueOne), .Data(valueTwo)) where valueOne == valueTwo:
                    dispatch(subscriber)
                default:
                    break
                }
            }
        }
        
        if !dispatched {
            throw Errors.dispatchFailed
        }
        
    }
}

class IntSubscriber : Subscriber {
    
    override var supportedData: [Data.InfoType] {
        return [Data.InfoType.Data(key: "int")]
    }
    
    override func receive(data: Data) {
        if let data = data as? IntData {
            print("Received number: \(data.value)")
        }
    }

}

class AllReceiveSubscriber : Subscriber {
    
    override var supportedData: [Data.InfoType] {
        return [Data.InfoType.Data(key: "all")]
    }
    
    override func receive(data: Data) {
        switch data {
            
        case let data as IntData:
            print("AllReceive got number = \(data.value)")
            
        case let data as StringData:
            print("AllReceive got string = \(data.value)")
            
        default:
            break
            
        }
    }
    
}

var subscriberOne = IntSubscriber()
var subscriberTwo = AllReceiveSubscriber()
var eventBus = EventBus()

do {
    try eventBus.register(subscriber: subscriberOne)
    try eventBus.register(subscriber: subscriberTwo)
    try eventBus.register(subscriber: subscriberOne)
} catch let value as EventBus.Errors {
    switch value {
    case .unsupportedSubscriber:
        print("Cannot subscribe!")
    case .subscriberAlreadyExists:
        print("Subscriber already exists!")
    default:
        break
    }
}

try! eventBus.post(data: IntData(value: 20, key: "int"))
try! eventBus.post(data: StringData(value: "Some data", key: "all"))

do {
    try eventBus.post(data: Data(type: .Control))
} catch let value as EventBus.Errors {
    switch value {
    case .dispatchFailed:
        print("Cannot dispatch Control pack!")
    default:
        break
    }
}

do {
    try eventBus.unregister(subscriber: subscriberOne)
    try eventBus.unregister(subscriber: subscriberTwo)
    try eventBus.unregister(subscriber: subscriberOne)
} catch is EventBus.Errors {
    print("Cannot unregister subscriber!")
}