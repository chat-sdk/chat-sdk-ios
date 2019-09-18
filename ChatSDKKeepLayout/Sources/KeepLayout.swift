//
//  KeepLayout.swift
//  Keep Layout
//
//  Created by Martin Kiss on 24.4.16.
//  Copyright © 2016 Martin Kiss. All rights reserved.
//



//MARK: KeepAttribute + Swift
/// Extension to redefine properties using Swift-compatible types.
protocol KeepAttribute_SwiftCompatibility {
    var equal: KeepValue { get set }
    var max: KeepValue { get set }
    var min: KeepValue  { get set }
}



//MARK: KeepValue + Swift
/// Redefined type to be usable from Swift.
public protocol KeepValue {
    var value: CGFloat { get }
    var priority: KeepPriority { get }
}

/// Default implementation for KeepValue.priority
public extension KeepValue {
    var priority: KeepPriority {
        return KeepPriorityRequired
    }
    var isNone: Bool {
        return self.value.isNaN
    }
}

/// Value, that represents no value. KeepNone.isNone will return true.
public let KeepNone: KeepValue = KeepValue_Decomposed(value: CGFloat.nan, priority: 0)

/// Constructor with arbitrary priority.
public func KeepValueMake(_ value: KeepValue, _ priority: KeepPriority) -> KeepValue {
    return KeepValue_Decomposed(value: value.value, priority: priority)
}

/// Constructors for 4 basic priorities
public func KeepRequired(_ value: KeepValue) -> KeepValue {
    return KeepValueMake(value, KeepPriorityRequired)
}
public func KeepHigh(_ value: KeepValue) -> KeepValue {
    return KeepValueMake(value, KeepPriorityHigh)
}
public func KeepLow(_ value: KeepValue) -> KeepValue {
    return KeepValueMake(value, KeepPriorityLow)
}
public func KeepFitting(_ value: KeepValue) -> KeepValue {
    return KeepValueMake(value, KeepPriorityFitting)
}



//MARK: KeepValue + Numbers

extension CGFloat: KeepValue {
    public var value: CGFloat {
        return self
    }
}

extension Double: KeepValue {
    public var value: CGFloat {
        return CGFloat(self)
    }
}

extension Float: KeepValue {
    public var value: CGFloat {
        return CGFloat(self)
    }
}

extension Int: KeepValue {
    public var value: CGFloat {
        return CGFloat(self)
    }
}

extension UInt: KeepValue {
    public var value: CGFloat {
        return CGFloat(self)
    }
}





//MARK: - Private Implementation



/// Easy comversion to bridging KeepValue type.
private extension KeepValue {
    var decomposed: KeepValue_Decomposed {
        return KeepValue_Decomposed(value: self.value, priority: self.priority)
    }
}



/// Internal conformance to KeepValue protocol.
extension KeepValue_Decomposed: KeepValue {
    var decomposed: KeepValue_Decomposed {
        return self
    }
}



/// Implementation of compatibility accessors.
extension KeepAttribute: KeepAttribute_SwiftCompatibility {
    
    private class var ThereIsABugInSwiftWhereRemovingThisPropertyCausesCompilationError: Bool { return true }
    
    public var equal: KeepValue {
        get {
            return self.decomposed_equal
        }
        set {
            self.decomposed_equal = newValue.decomposed
        }
    }
    
    public var max: KeepValue {
        get {
            return self.decomposed_max
        }
        set {
            self.decomposed_max = newValue.decomposed
        }
    }
    
    public var min: KeepValue {
        get {
            return self.decomposed_min
        }
        set {
            self.decomposed_min = newValue.decomposed
        }
    }
    
}


