import Foundation

class FeedbackCollector {
  let pageFactory: PageFactory
  init(pageFactory: PageFactory) {
    self.pageFactory = pageFactory
  }

  func collectFeedbackModelChange() -> Signal<FeedbackModelChange> {
    return pageFactory.signalMakeMainPage
      .flatMap { $0.signalPolarizedChanged }
      .map(FeedbackModel.transformWithPolarized)
      + pageFactory.signalMakeSelectionPage
        .flatMap { $0.signalSelection }
        .map(FeedbackModel.transformWithFeedback)
  }
}