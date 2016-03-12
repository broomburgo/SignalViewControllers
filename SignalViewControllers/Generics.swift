import Foundation

infix operator § { associativity right precedence 40 }
public func § <A, B> (left: A -> B, right: A) -> B {
  return left(right)
}

func once<T>(callback: T -> ()) -> T -> Persistence {
  return {
    callback($0)
    return .Stop
  }
}

func always<T>(callback: T -> ()) -> T -> Persistence {
  return {
    callback($0)
    return .Continue
  }
}

func doAll<T>(callbacks: [T -> ()]) -> T -> () {
  return {
    for callback in callbacks {
      callback($0)
    }
  }
}

func inAnyCase<T>(callback: () -> ()) -> T -> () {
  return { _ in
    callback()
  }
}
