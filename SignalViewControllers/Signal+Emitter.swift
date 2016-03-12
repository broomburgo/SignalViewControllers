import Foundation

public enum Persistence {
  case Stop
  case Continue
}

public final class Signal<Subtype> {
  typealias Observation = Subtype -> Persistence

  private var observations: [Observation] = []

  public init() {}

  public func onReception (observeFunction: Subtype -> Persistence) -> Signal {
    observations.append(observeFunction)
    return self
  }

  public func map<OtherSubtype>(transform: Subtype -> OtherSubtype) -> Signal<OtherSubtype> {
    let mappedSignal = Signal<OtherSubtype>()
    onReception {
      mappedSignal.send(transform($0))
      return .Continue
    }
    return mappedSignal
  }

  public func flatMap<OtherSubtype>(transform: Subtype -> Signal<OtherSubtype>) -> Signal<OtherSubtype> {
    let mappedSignal = Signal<OtherSubtype>()
    onReception {
      transform($0).onReception {
        mappedSignal.send($0)
        return .Continue
      }
      return .Continue
    }
    return mappedSignal
  }
}

extension Signal {
  private func send (value: Subtype) {
    var newObservations: [Observation] = []
    while observations.count > 0 {
      let observe = observations.removeFirst()
      let persistence = observe(value)
      switch persistence {
      case .Continue:
        newObservations.append(observe)
      case .Stop: break
      }
    }
    observations = newObservations
  }
}

public final class Emitter<Subtype> {
  public let signal = Signal<Subtype>()

  public func emit(value: Subtype) {
    signal.send(value)
  }
}
