import Foundation

enum Feedback: Int {
  case None       = 0
  case VeryBad  = 1
  case Bad        = 2
  case SoAndSo    = 3
  case Good       = 4
  case ReallyGood = 5
}

extension Feedback {
  var description: String? {
    switch self {
    case .None: return nil
    case .VeryBad: return "very bad"
    case .Bad: return "bad"
    case .SoAndSo: return "so and so"
    case .Good: return "good"
    case .ReallyGood: return "really good"
    }
  }
}

struct FeedbackModel {
  let feedback: Feedback
  let polarized: Bool
  init(feedback: Feedback, polarized: Bool) {
    self.feedback = feedback
    self.polarized = polarized
  }
}

typealias FeedbackModelChange = FeedbackModel -> FeedbackModel

extension FeedbackModel {
  static func transformWithPolarized(polarized: Bool) -> FeedbackModelChange {
    return {
      FeedbackModel(feedback: $0.feedback, polarized: polarized)
    }
  }

  static func transformWithFeedback(feedback: Feedback) -> FeedbackModelChange {
    return {
      FeedbackModel(feedback: feedback, polarized: $0.polarized)
    }
  }
}
