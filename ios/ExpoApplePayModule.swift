import ExpoModulesCore

public class ExpoApplePayModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoApplePay")

    View(ExpoApplePayView.self) {
      Events("onTokenReceived")
      
      AsyncFunction("onTokenSuccess") { (view: ExpoApplePayView) in
        view.applePayView.onTokenSuccess()
      }

      AsyncFunction("onTokenFailed") { (view: ExpoApplePayView) in
        view.applePayView.onTokenFailed()
      }

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
    }
  }
}