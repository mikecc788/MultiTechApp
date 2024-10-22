//
//  ViewController.swift
//  CodeHelper
//
//  Created by app on 2023/4/20.
//

import Cocoa

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       
        barrier()
       
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func barrier(){
        let queueSync = DispatchQueue(label: "com.example.ReadWriteQueue", attributes: .concurrent)
        queueSync.async {
            for i in 0..<2 {
                    print("我是任务一、来自线程：\(Thread.current) \(i)")
            }
        }
        
        queueSync.async {
            for i in 0..<2 {
                    print("我是任务二、来自线程：\(Thread.current) \(i)")
            }
        }
        
        queueSync.async (flags:.barrier){
            
        }
        
        queueSync.async {
            for i in 0..<2 {
                    print("我是任务三、来自线程：\(Thread.current) \(i)")
            }
        }
        
        
        
        
    }

    
    func globalDemo(){
        let globalQueue = DispatchQueue.global()

        print("0\(Thread.current)")
          
//        DispatchQueue.main.sync {
//
//
//        }
        DispatchQueue.main.async {
            print("1\(Thread.current)")
        }
        print("2\(Thread.current)")
    }
    
}

