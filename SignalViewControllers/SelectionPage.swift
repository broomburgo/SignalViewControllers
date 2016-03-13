import UIKit

class SelectionPage: UIViewController {
  private let selectionEmitter = Emitter<Feedback>()

  var signalSelection: Signal<Feedback> {
    return selectionEmitter.signal
  }

  var page: UIViewController {
    return self
  }

  init(feedbackModelController: ModelController<FeedbackModel>) {
    let nibName = feedbackModelController.model.polarized
      ? "PolarizedSelectionPage"
      : "AverageSelectionPage"
    super.init(nibName: nibName, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  @IBAction func didTapFeedbackButton(sender: UIButton) {
    guard let feedback = Feedback(rawValue: sender.tag) else { return }
    selectionEmitter.emit(feedback)
  }
}
