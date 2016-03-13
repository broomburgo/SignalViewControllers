import Foundation

class FeedbackCollector {
  let pageFactory: PageFactory
  init(pageFactory: PageFactory) {
    self.pageFactory = pageFactory
  }

//  private var currentSignal = Signal<FeedbackModelChange>()

  func collectFeedbackModelChange() -> Signal<FeedbackModelChange> {
    let currentSignal = pageFactory.signalMakeMainPage
      .flatMap { $0.signalPolarizedChanged }
      .map(FeedbackModel.transformWithPolarized)
      + pageFactory.signalMakeSelectionPage
        .flatMap { $0.signalSelection }
        .map(FeedbackModel.transformWithFeedback)
    return currentSignal
  }
}