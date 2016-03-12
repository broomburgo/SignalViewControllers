import UIKit

enum Classification: Int {
  case ReallyGood = 1
  case Good       = 2
  case SoAndSo    = 3
  case Bad        = 4
  case ReallyBad  = 5
}

extension Classification: CustomStringConvertible {
  var description: String {
    switch self {
    case .ReallyGood: return "really good"
    case .Good: return "good"
    case .SoAndSo: return "so and so"
    case .Bad: return "bad"
    case .ReallyBad: return "really bad"
    }
  }
}

class SelectionPage: UIViewController, SelectionController {
  private let selectionEmitter = Emitter<Classification>()

  var signalSelection: Signal<Classification> {
    return selectionEmitter.signal
  }

  var page: UIViewController {
    return self
  }

  @IBAction func didTapClassificationButton(sender: UIButton) {
    guard let classification = Classification(rawValue: sender.tag) else { return }
    selectionEmitter.emit(classification)
  }
}
