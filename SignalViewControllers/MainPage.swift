import UIKit

class MainPage: UIViewController {
  private let polarizedChangedEmitter = Emitter<Bool>()
  private let leaveFeedbackEmitter = Emitter<UIButton>()
  private let viewReadyEmitter = Emitter<()>()

  var signalPolarizedChanged: Signal<Bool> {
    return polarizedChangedEmitter.signal
  }

  var signalLeaveFeedback: Signal<UIButton> {
    return leaveFeedbackEmitter.signal
  }

  init(feedbackModelController: ModelController<FeedbackModel>) {
    super.init(nibName: nil, bundle: nil)
    feedbackModelController.updateSignal.onReception § always § updateViewsWithFeedbackModel
    viewReadyEmitter.signal.onReception § always § feedbackModelController.notify
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    viewReadyEmitter.emit()
  }

  @IBOutlet weak var feedbackLabel: UILabel?

  @IBOutlet weak var polarizedSelector: UISegmentedControl?

  @IBAction func didChangePolarizedSelector(sender: UISegmentedControl) {
    polarizedChangedEmitter.emit(sender.selectedSegmentIndex == 1)
  }

  @IBAction func didTapLeaveFeedbackButton(sender: UIButton) {
    leaveFeedbackEmitter.emit(sender)
  }

  private func updateViewsWithFeedbackModel(model: FeedbackModel) {
    feedbackLabel?.text = model.feedback.description.map { "the movie was " + $0 }
    polarizedSelector?.selectedSegmentIndex = model.polarized ? 1 : 0
  }
}
