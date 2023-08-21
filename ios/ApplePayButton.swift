import ExpoModulesCore
import UIKit
import CoreMotion
import PassKit

class ApplePayButton: UIView, PKPaymentAuthorizationViewControllerDelegate {
  lazy var payButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
  var onTokenReceived: EventDispatcher? = nil
  lazy var merchantIdentifier: String = ""
  lazy var countryCode: String = ""
  lazy var currencyCode: String = ""
  lazy var amount: Double = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(payButton)
    payButton.addTarget(self, action: #selector(startApplePay), for: .touchUpInside)
  }

  func setEventDispatcher(_ eventDispatcher: EventDispatcher) {
    self.onTokenReceived = eventDispatcher
  }

  func setMerchantIdentifier(_ text: String) {
    self.merchantIdentifier = text
  }

  func setCountryCode(_ text: String) {
     self.countryCode = text
  }

  func setCurrencyCode(_ text: String) {
     self.currencyCode = text
  }

  func setAmount(_ text: Double) {
    self.amount = text
  }

  func showAlert(_ title: String, _ message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
  }

  @objc func startApplePay() {
    if PKPaymentAuthorizationViewController.canMakePayments() {
    let request = PKPaymentRequest()
    request.merchantIdentifier = self.merchantIdentifier
    request.supportedNetworks = [.visa, .masterCard]
    request.merchantCapabilities = .capability3DS
    request.countryCode = self.countryCode // Votre code de pays
    request.currencyCode = self.currencyCode // Votre devise
    let amount = NSDecimalNumber(value: self.amount)
    request.paymentSummaryItems = [
        PKPaymentSummaryItem(label: "Votre produit", amount: amount)
    ]

    let vc = PKPaymentAuthorizationViewController(paymentRequest: request)
    vc?.delegate = self
    UIApplication.shared.keyWindow?.rootViewController?.present(vc!, animated: true, completion: nil)
  } else {
    showAlert("Erreur", "Apple Pay n'est pas supporté sur cet appareil")
  }
}

  func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
      // print(payment.token)
      // let paymentData = payment.token.paymentData
      let paymentData = payment.token.paymentData
      let paymentNetwork = payment.token.paymentMethod.network?.rawValue ?? "unknown"

      let paymentDict: [String: Any] = [
        "transactionIdentifier": payment.token.transactionIdentifier,
        "paymentData": paymentData.base64EncodedString(),
        "paymentNetwork": paymentNetwork
      ]

      if let jsonData = try? JSONSerialization.data(withJSONObject: paymentDict, options: .prettyPrinted),
        let jsonString = String(data: jsonData, encoding: .utf8) {
        self.onTokenReceived?(["payment": jsonString, "payment2": NSString(data: token.paymentData, encoding: NSUTF8StringEncoding)])
      }
      
      //completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didFailWithError error: Error) {
     showAlert("Erreur", "Le paiement Apple Pay a échoué : \(error.localizedDescription)")
}

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
