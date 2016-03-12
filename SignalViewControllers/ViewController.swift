import UIKit

class ViewController: UIViewController {

  var selectionPageFactory: SelectionPageFactory? {
    didSet {
      guard let factory = selectionPageFactory else { return }
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

  @IBAction func didTapLeaveFeedbackButton(sender: UIButton) {
    guard let factory = selectionPageFactory else { return }
    navigationController?.pushViewController(
      factory.makePageWithTitle("The movie was..."), animated: true)
  }
}
