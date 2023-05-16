//
//  MainRunLoopActivityObserver.swift
//  
//
//  Created by Enrique Garcia Alvarez on 28/12/22.
//

import Foundation

let register = {
    MainRunLoopActivityObserver {
        debugPrint("RunLoop - Entry")
    }
}()

public class MainRunLoopActivityObserver {

    let observer: CFRunLoopObserver?

    init(callback: @escaping () -> Void) {
        let activity = CFRunLoopActivity.entry.rawValue
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                          activity,
                                                          true,
                                                          Int.max) { observer, activity in
            callback()
        }

        CFRunLoopAddObserver(CFRunLoopGetMain(),
                             observer,
                             CFRunLoopMode.defaultMode)
        self.observer = observer
    }

    deinit {
        observer.map {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(),
                                    $0,
                                    CFRunLoopMode.defaultMode);
        }
    }
}
