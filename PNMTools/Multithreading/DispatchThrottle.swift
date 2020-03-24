//
//  DispatchThrottle.swift
//  Mapper
//
//  Created by Brett on 11/15/19.
//  Copyright © 2019 Brett. All rights reserved.
//

import Foundation

struct DispatchThrottle {
    
    let workItem: DispatchWorkItem
    
    init (queue: DispatchQueue, timeInterval: TimeInterval = 0.35,
        _ work: @escaping () -> Void){
        workItem = DispatchWorkItem(block: work)
        queue.asyncAfter(deadline: .now() + timeInterval, execute: workItem)
    }
    
    func cancel(){
        workItem.cancel()
    }
}

/// Sample class to demonstrate usage.
class DispatchThrottle_Test {
    var throttle: DispatchThrottle?
    
    func doTask(_ task: @escaping () -> Void) {
        throttle?.cancel()
        throttle = DispatchThrottle(queue: .global(), task)
    }
}
