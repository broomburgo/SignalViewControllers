import UIKit

class ViewController: UIViewController {

  var selectionControllerFactory: SelectionControllerFactory? {
    didSet {
      guard let factory = selectionControllerFactory else { return }
      factory.signalMakePage
        .flatMap { $0.signalSelection }
        .onReception § always § doAll § [
          updateFeedbackLabelWithClassification,
          inAnyCase § navigateBack
      ]
    }
  }

  func updateFeedbackLabelWithClassification(classification: Classification) {
    feedbackLabel?.text = "the movie was " + classification.description
  }

  func navigateBack() {
    guard let navController = navigationController else { return }
    guard navController.topViewController != self else { return }
    navigationController?.popToViewController(self, animated: true)
  }

  @IBOutlet weak var feedbackLabel: UILabel?

  @IBOutlet weak var polarizedSelector: UISegmentedControl? {
    didSet {
      polarizedSelector?.selectedSegmentIndex = 0
    }
  }

  @IBAction func didTapLeaveFeedbackButton(sender: UIButton) {
    guard let factory = selectionControllerFactory else { return }
    guard let selector = polarizedSelector else { return }
    navigationController?.pushViewController(
      factory.makePage(
        title: "The movie was...",
        polarized: selector.selectedSegmentIndex == 1)
        .page,
      animated: true)
  }
}
