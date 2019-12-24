//
//  RateLimiter.swift
//  GitHubRepoSearcher
//
//  Created by K Y on 12/19/19.
//  Copyright © 2019 Yu. All rights reserved.
//

import Foundation

/*
 // Two potential scenarios:
 // 1. we're withing the limit and it's fine to proceed
 // 2. We've hit the limit, and so, work becomes enqueued.
 
 // RateLimiter
 // * stops all requests if we reach the permitted rate
 // * once we hit the limit, we enqueue any extra requests
 // * effectively a time-based queue with throughput that stops at a given frequency
 
 // * not thread-safe yet.
 */

class RateLimiter {
    
    // MARK: - Constant Properties
    
    /// the time in which a `thoughput`-amount of requests may be made
    let interval: TimeInterval
    /// the amount of tasks that may be done each `interval`
    let throughput: Int
    
    // MARK: - Task-tracking Properties
    
    /// checks the time and amount of enqueued tasks if it is full
    var isFull: Bool {
        guard let flushTime = flushTime else { return false }
        let time = Date().timeIntervalSince(flushTime)
        return count > throughput && time < interval
    }
    /// the start time of the current `interval`
    private(set) var flushTime: Date!
    /// dispatchWorkItem to retry the requests within the queue after some time
    private(set) var flushTask: DispatchWorkItem!
    /// the number of tasks performed within the current `interval`
    private(set) var count: Int = 0
    /// all enqueued requests that exceed the `throughput` per `interval`
    private(set) var tasks = BarrierArray<()->Void>([])
    
    // MARK: - Initializers and Destructor
    
    /// `interval` - seconds in which a max of `throughput` tasks may be performed
    init(_ interval: TimeInterval, throughput: Int) {
        self.interval = interval
        self.throughput = throughput
    }
    
    deinit {
        flushTask?.cancel()
    }
    
    // MARK: - Methods
    
    /// call this to time-throttle some task, or enqueue it
    func limit(_ task: @escaping ()->Void) {
        // if there is no tasks, setup flush time and schedule
        // a time to reset the counter
        if flushTask == nil {
            flushTime = Date()
            flushTask = DispatchWorkItem(block: requeue)
            DispatchQueue.global().asyncAfter(deadline: .now() + interval,
                                              execute: flushTask)
        }
        
        // increment the amount of tasks being done
        count += 1
        
        // check: do we perform the task or enqueue it?
        if isFull {
            tasks.append(task)
        }
        else {
            task()
        }
    }
    
    /// called by the timer, resets the queue and performs as many tasks as possible
    func requeue() {
        let tasks = flush()
        // this could be optimized, just a bit...
        for task in tasks.array {
            limit(task)
        }
    }
    
    /// flushes the queue, removes all scheduled tasks
    /// call `limit:task` again to start the workflow
    @discardableResult
    func flush() -> BarrierArray<()->Void> {
        count = 0
        let t = tasks
        tasks.removeAll(keepingCapacity: true)
        return t
    }
    
}

/// helper class to print when requeueing is performed
class RateLimiter_debug: RateLimiter {
    
    override func limit(_ task: @escaping ()->Void) {
        let str = isFull
            ? "limiter is full, enqueuing task"
            : "performing task"
        print(str)
        super.limit(task)
    }
    
    override func requeue() {
        let time = Date().timeIntervalSince(flushTime)
        let c = tasks.count
        let str = (c > 0)
            ? "now requeueing \(c) tasks at \(time)"
            : "no tasks to requeue"
        print(str)
        super.requeue()
    }
    
    @discardableResult
    override func flush() -> BarrierArray<()->Void>  {
        print("did flush \(count) tasks")
        return super.flush()
    }
    
    
}
