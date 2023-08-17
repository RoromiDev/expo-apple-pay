import ExpoModulesCore

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
    }
  }
}