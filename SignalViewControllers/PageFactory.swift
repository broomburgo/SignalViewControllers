import Foundation

class PageFactory {
  private let makeMainPageEmitter = Emitter<MainPage>()
  private let makeSelectionPageEmitter = Emitter<SelectionPage>()

  var signalMakeMainPage: Signal<MainPage> {
    return makeMainPageEmitter.signal
  }

  var signalMakeSelectionPage: Signal<SelectionPage> {
    return makeSelectionPageEmitter.signal
  }

  let mainPageTitle: String
  let selectionPageTitle: String
  let modelController: ModelController<FeedbackModel>
  init(
    mainPageTitle: String,
    selectionPageTitle: String,
    feedbackModelController: ModelController<FeedbackModel>)
  {
    self.mainPageTitle = mainPageTitle
    self.selectionPageTitle = selectionPageTitle
    self.modelController = feedbackModelController
  }

  func makeMainPage() -> MainPage {
    let page = MainPage(feedbackModelController: modelController)
    page.title = mainPageTitle
    makeMainPageEmitter.emit(page)
    return page
  }

  func makeSelectionPage() -> SelectionPage {
    let page = SelectionPage(feedbackModelController: modelController)
    page.title = selectionPageTitle
    makeSelectionPageEmitter.emit(page)
    return page
  }
}
