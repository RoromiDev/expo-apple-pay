import ExpoModulesCore

public class ExpoApplePayModule: Module {
    public func definition() -> ModuleDefinition {
        Name("ExpoApplePay")

        View(ExpoApplePayView.self) {
            Events("onTokenReceived")
            
            // MARK: - View Functions
            AsyncFunction("onTokenSuccess") { (view: ExpoApplePayView) in
                view.applePayView.onTokenSuccess()
            }

            AsyncFunction("onTokenFailed") { (view: ExpoApplePayView) in
                view.applePayView.onTokenFailed()
            }

            // MARK: - Payment Configuration Props
            Prop("merchantIdentifier") { (view, value: String) in
                view.applePayView.setMerchantIdentifier(value)
            }
            
            Prop("countryCode") { (view, value: String) in
                view.applePayView.setCountryCode(value)
            }
            
            Prop("currencyCode") { (view, value: String) in
                view.applePayView.setCurrencyCode(value)
            }
            
            Prop("amount") { (view, value: Double) in
                view.applePayView.setAmount(value)
            }
            
            Prop("paymentSummaryItems") { (view, items: [[String: Any]]) in
                view.applePayView.setPaymentSummaryItems(items)
            }
            
            // MARK: - Button Appearance Props
            Prop("height") { (view, value: Double) in
                view.applePayView.setHeight(value)
            }
            
            Prop("width") { (view, value: Double) in
                view.applePayView.setWidth(value)
            }
            
            Prop("type") { (view, value: String) in
                view.applePayView.setButtonType(value)
            }
            
            Prop("buttonStyle") { (view, value: String) in
                view.applePayView.setButtonStyle(value)
            }
            
            Prop("cornerRadius") { (view, value: Double) in
                view.applePayView.setCornerRadius(value)
            }
            
            // MARK: - Payment Network Props
            Prop("supportedNetworks") { (view, networks: [String]) in
                view.applePayView.setSupportedNetworks(networks)
            }
            
            Prop("merchantCapabilities") { (view, capabilities: [String]) in
                view.applePayView.setMerchantCapabilities(capabilities)
            }
        }
    }
}
