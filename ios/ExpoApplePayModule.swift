import ExpoModulesCore

public class Callback: AnyArgument {
    let callback: (Any) -> Any

    public init(_ callback: @escaping (Any) -> Any) {
        self.callback = callback
    }
}

public class ExpoApplePayModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoApplePay")

    View(ExpoApplePayView.self) {
      Prop("merchantIdentifier") { (view, text: String) in
        view.applePayView.setMerchantIdentifier(text)
      }
      Prop("countryCode") { (view, text: String) in
        view.applePayView.setCountryCode(text)
      }
      Prop("currencyCode") { (view, text: String) in
        view.applePayView.setCurrencyCode(text)
      }
      Prop("amount") { (view, text: Double) in
        view.applePayView.setAmount(text)
      }
      Prop("onSuccess") { (view, callback: Callback) in
        view.applePayView.setOnSuccess(callback.callback)
      }
      Prop("onError") { (view, callback: Callback) in
        view.applePayView.setOnError(callback.callback)
      }
    }
  }
}