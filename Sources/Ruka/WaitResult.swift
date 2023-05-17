//
//  WaitResult.swift
//  
//
//  Created by Enrique Garcia Alvarez on 18/5/23.
//

import Foundation

public enum WaitResult {
    case wait, success
}

func getAbsoluteTimeMs() -> UInt {
    var info = mach_timebase_info(numer: 0, denom: 0)
    mach_timebase_info(&info)
    let numer = UInt64(info.numer)
    let denom = UInt64(info.denom)
    let nanoseconds = (mach_absolute_time() * numer) / denom
    return UInt(nanoseconds / NSEC_PER_MSEC)
}
