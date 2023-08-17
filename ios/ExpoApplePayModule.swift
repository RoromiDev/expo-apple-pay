import ExpoModulesCore

public class ExpoApplePayModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoApplePay")

    View(ExpoApplePayView.self) {
      Prop("merchantIdentifier") { (view, text: String) in
        view.gyroView.setMerchantIdentifier(text)
      }
      Prop("countryCode") { (view, text: String) in
        view.gyroView.setCountryCode(text)
      }
      Prop("currencyCode") { (view, text: String) in
        view.gyroView.setCurrencyCode(text)
      }
      Prop("amount") { (view, text: Double) in
        view.gyroView.setAmount(text)
      }
    }
  }
}