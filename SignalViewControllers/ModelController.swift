public final class ModelController<ModelType> {
  private let updateEmitter = Emitter<ModelType>()
  private let deltaEmitter = Emitter<(ModelType, ModelType)>()

  public var updateSignal: Signal<ModelType> {
    return updateEmitter.signal
  }

  public var deltaSignal: Signal<(ModelType, ModelType)> {
    return deltaEmitter.signal
  }

  public private(set) var model: ModelType {
    didSet {
      updateEmitter.emit(model)
      deltaEmitter.emit((oldValue, model))
    }
  }

  public init (model: ModelType) {
    self.model = model
  }

  public func observe(callback: ModelType -> Persistence) {
    updateSignal.onReception(callback)
  }

  public func notify() {
    updateEmitter.emit(model)
  }

  public func update(newValue: ModelType) {
    transform { _ in newValue }
  }

  public func transform(change: ModelType -> ModelType) {
    model = change(model)
  }
}
