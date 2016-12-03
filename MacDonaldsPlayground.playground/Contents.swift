//: Playground - noun: a place where people can play

import UIKit

class Queue {
    
    var count = 0
    
    func add(count: Int = 1) {
        self.count += count
    }
    
    func remove(count: Int = 1) {
        self.count -= count
    }
    
    var isEmpty: Bool {
        return count == 0
    }
    
}

class Event {
    
    let time: Double
    let action: () -> Void
    
    init(time: Double, action: @escaping () -> Void) {
        self.time = time
        self.action = action
    }
    
}

class Shop {
    
    var queues: [Queue] = []
    var events: [Event] = []
    var queueTotalCount = 0
    
    init(count: Int) {
        for _ in 1...count {
            queues.append(Queue())
        }
    }
    
    func modeling(totalTime: Double) {
        var time = 0.0
        
        for queue in queues {
            addTask(queue: queue, time: time)
            events.append(Event(time: time) {
                self.grabTask(queue: queue, time: time)
            })
        }
        
        while time < totalTime {
            let event = getMinTimeEvent()
            time = event.time
            event.action()
        }
    }
    
    func getMinTimeEvent() -> Event {
        var event = events.first!
        var index = 0
        
        for i in 1..<events.count {
            
            if events[i].time < event.time {
                event = events[i]
                index = i
            }
        }
        
        events.remove(at: index)
        return event
    }
    
    func grabTask(queue: Queue, time: Double) {
        queue.remove()
        queueTotalCount += 1
        let dt = Double(arc4random() % 10 + 5)
        self.events.append(Event(time: time + dt) {
            self.grabTask(queue: queue, time: time + dt)
        })
    }
    
    func addTask(queue: Queue, time: Double) {
        queue.add()
        let dt = Double(arc4random() % 4 + 1)
        events.append(Event(time: time + dt) {
            self.addTask(queue: queue, time: time + dt)
        })
    }
}

let shop = Shop(count: 3)
shop.modeling(totalTime: 100)
print("Total queue count = \(shop.queueTotalCount)")