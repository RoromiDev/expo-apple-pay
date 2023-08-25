import ExpoModulesCore
import UIKit
import CoreMotion
import PassKit
import os.log

class ApplePayButton: UIView, PKPaymentAuthorizationViewControllerDelegate {
  lazy var payButton: PKPaymentButton = {
    return PKPaymentButton(paymentButtonType: .pay, paymentButtonStyle: .black)
  }()
  var onTokenReceived: EventDispatcher? = nil
  lazy var merchantIdentifier: String = ""
  lazy var countryCode: String = ""
  lazy var currencyCode: String = ""
  lazy var amount: Double = 0
  lazy var height: Double = 0
  lazy var width: Double = 0
  lazy var paymentSummaryItems: Array<PKPaymentSummaryItem> = []
  var completion: ((PKPaymentAuthorizationResult) -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
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

  @objc func setWidth(_ text: Double) {
    self.width = text
   NSLayoutConstraint.activate([
      payButton.widthAnchor.constraint(equalToConstant: text)
    ])
  }

  @objc func setHeight(_ text: Double) {
     self.height = text
    NSLayoutConstraint.activate([
      payButton.heightAnchor.constraint(equalToConstant: text)
    ])
  }

  @objc func setButtonType(_ text: String) {
    payButton.removeFromSuperview()
    if (text == "book") {
      if #available(iOS 11.2, *) {
        payButton = PKPaymentButton(paymentButtonType: .book, paymentButtonStyle: .black)
      } else {
        payButton = PKPaymentButton(paymentButtonType: .pay, paymentButtonStyle: .black)
      }
    } else {
      payButton = PKPaymentButton(paymentButtonType: .pay, paymentButtonStyle: .black)
    }
    self.addSubview(payButton)
    payButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      payButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      payButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      payButton.widthAnchor.constraint(equalToConstant: self.width),
      payButton.heightAnchor.constraint(equalToConstant: self.height)
    ])
    payButton.addTarget(self, action: #selector(startApplePay), for: .touchUpInside)
  }

  func showAlert(_ title: String, _ message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
  }

  func setPaymentSummaryItems(_ items: Array<[String: Any]>) {
    self.paymentSummaryItems = items.map { item in
      if let label = item["label"] as? String,
         let amount = item["amount"] as? Double {
        return PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(value: amount))
      }
      return nil
    }.compactMap { $0 }
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
    request.paymentSummaryItems = self.paymentSummaryItems
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
      self.completion = completion
      self.onTokenReceived?([
        "transactionIdentifier": payment.token.transactionIdentifier,
        "paymentData": NSString(data: payment.token.paymentData, encoding: NSUTF8StringEncoding),
        "paymentNetwork": payment.token.paymentMethod.network,
      ])
  }

  func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didFailWithError error: Error) {
     showAlert("Erreur", "Le paiement Apple Pay a échoué : \(error.localizedDescription)")
  }

  @objc func onTokenSuccess() {
    self.completion?(PKPaymentAuthorizationResult(status: .success, errors: nil))
  }

  @objc func onTokenFailed() {
    let error = NSError(domain: "", code: 200, userInfo: [NSLocalizedDescriptionKey : "Failed to complete payment"])
    self.completion?(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
