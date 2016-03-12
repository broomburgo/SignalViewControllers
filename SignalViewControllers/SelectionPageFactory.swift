import Foundation

class SelectionPageFactory {
  private let makePageEmitter = Emitter<SelectionPage>()

  var signalMakePage: Signal<SelectionPage> {
    return makePageEmitter.signal
  }

  func makePageWithTitle(title: String) -> SelectionPage {
    let page = SelectionPage()
    page.title = title
    makePageEmitter.emit(page)
    return page
  }
}
