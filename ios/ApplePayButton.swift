import ExpoModulesCore
import UIKit
import PassKit

class ApplePayButton: UIView, PKPaymentAuthorizationViewControllerDelegate {
    
    // MARK: - Properties
    var onTokenReceived: EventDispatcher? = nil
    var completion: ((PKPaymentAuthorizationResult) -> Void)?
    
    // Payment configuration
    private var merchantIdentifier: String = ""
    private var countryCode: String = ""
    private var currencyCode: String = ""
    private var amount: Double = 0
    private var paymentSummaryItems: [PKPaymentSummaryItem] = []
    
    // Button configuration
    private var buttonWidth: Double = 200
    private var buttonHeight: Double = 44
    private var buttonTypeValue: PKPaymentButtonType = .plain
    private var buttonStyleValue: PKPaymentButtonStyle = .black
    private var buttonCornerRadius: Double = 4
    private var supportedNetworksValue: [PKPaymentNetwork] = [.visa, .masterCard]
    private var merchantCapabilitiesValue: PKMerchantCapability = .capability3DS
    
    // Button instance
    private var payButton: PKPaymentButton?
    
    // Track if we need to rebuild the button
    private var needsButtonRebuild = true
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        if needsButtonRebuild {
            rebuildButton()
            needsButtonRebuild = false
        }
    }
    
    // MARK: - Event Dispatcher
    func setEventDispatcher(_ eventDispatcher: EventDispatcher) {
        self.onTokenReceived = eventDispatcher
    }
    
    // MARK: - Payment Configuration Setters
    func setMerchantIdentifier(_ value: String) {
        self.merchantIdentifier = value
    }
    
    func setCountryCode(_ value: String) {
        self.countryCode = value
    }
    
    func setCurrencyCode(_ value: String) {
        self.currencyCode = value
    }
    
    func setAmount(_ value: Double) {
        self.amount = value
    }
    
    func setPaymentSummaryItems(_ items: [[String: Any]]) {
        self.paymentSummaryItems = items.compactMap { item in
            guard let label = item["label"] as? String,
                  let amount = item["amount"] as? Double else {
                return nil
            }
            let itemType = (item["type"] as? String) == "pending" 
                ? PKPaymentSummaryItemType.pending 
                : PKPaymentSummaryItemType.final
            return PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(value: amount), type: itemType)
        }
    }
    
    // MARK: - Button Configuration Setters
    func setWidth(_ value: Double) {
        if self.buttonWidth != value {
            self.buttonWidth = value
            needsButtonRebuild = true
            setNeedsLayout()
        }
    }
    
    func setHeight(_ value: Double) {
        if self.buttonHeight != value {
            self.buttonHeight = value
            needsButtonRebuild = true
            setNeedsLayout()
        }
    }
    
    func setButtonType(_ value: String) {
        let newType = Self.parseButtonType(value)
        if self.buttonTypeValue != newType {
            self.buttonTypeValue = newType
            needsButtonRebuild = true
            setNeedsLayout()
        }
    }
    
    func setButtonStyle(_ value: String) {
        let newStyle = Self.parseButtonStyle(value)
        if self.buttonStyleValue != newStyle {
            self.buttonStyleValue = newStyle
            needsButtonRebuild = true
            setNeedsLayout()
        }
    }
    
    func setCornerRadius(_ value: Double) {
        if self.buttonCornerRadius != value {
            self.buttonCornerRadius = value
            needsButtonRebuild = true
            setNeedsLayout()
        }
    }
    
    func setSupportedNetworks(_ networks: [String]) {
        self.supportedNetworksValue = networks.compactMap { Self.parseNetwork($0) }
    }
    
    func setMerchantCapabilities(_ capabilities: [String]) {
        var caps: PKMerchantCapability = []
        for cap in capabilities {
            switch cap.lowercased() {
            case "3ds", "capability3ds":
                caps.insert(.capability3DS)
            case "emv", "capabilityemv":
                caps.insert(.capabilityEMV)
            case "credit", "capabilitycredit":
                caps.insert(.capabilityCredit)
            case "debit", "capabilitydebit":
                caps.insert(.capabilityDebit)
            default:
                break
            }
        }
        self.merchantCapabilitiesValue = caps.isEmpty ? .capability3DS : caps
    }
    
    // MARK: - Button Type Parser
    private static func parseButtonType(_ value: String) -> PKPaymentButtonType {
        switch value.lowercased() {
        case "plain":
            return .plain
        case "buy":
            return .buy
        case "setup", "setup":
            return .setUp
        case "instore", "in-store":
            return .inStore
        case "donate":
            return .donate
        case "checkout":
            return .checkout
        case "book":
            return .book
        case "subscribe":
            return .subscribe
        case "reload":
            if #available(iOS 14.0, *) {
                return .reload
            }
            return .plain
        case "addmoney", "add-money":
            if #available(iOS 14.0, *) {
                return .addMoney
            }
            return .plain
        case "topup", "top-up":
            if #available(iOS 14.0, *) {
                return .topUp
            }
            return .plain
        case "order":
            if #available(iOS 14.0, *) {
                return .order
            }
            return .plain
        case "rent":
            if #available(iOS 14.0, *) {
                return .rent
            }
            return .plain
        case "support":
            if #available(iOS 14.0, *) {
                return .support
            }
            return .plain
        case "contribute":
            if #available(iOS 14.0, *) {
                return .contribute
            }
            return .plain
        case "tip":
            if #available(iOS 14.0, *) {
                return .tip
            }
            return .plain
        case "continue":
            return .continue
        default:
            return .plain
        }
    }
    
    // MARK: - Button Style Parser
    private static func parseButtonStyle(_ value: String) -> PKPaymentButtonStyle {
        switch value.lowercased() {
        case "white":
            return .white
        case "whiteoutline", "white-outline":
            return .whiteOutline
        case "black":
            return .black
        case "automatic", "auto":
            if #available(iOS 14.0, *) {
                return .automatic
            }
            return .black
        default:
            return .black
        }
    }
    
    // MARK: - Network Parser
    private static func parseNetwork(_ value: String) -> PKPaymentNetwork? {
        switch value.lowercased() {
        case "visa":
            return .visa
        case "mastercard":
            return .masterCard
        case "amex", "americanexpress":
            return .amex
        case "discover":
            return .discover
        case "chinaUnionPay", "chinaunionpay", "unionpay":
            return .chinaUnionPay
        case "interac":
            return .interac
        case "jcb":
            return .JCB
        case "maestro":
            if #available(iOS 12.0, *) {
                return .maestro
            }
            return nil
        case "electron":
            if #available(iOS 12.0, *) {
                return .electron
            }
            return nil
        case "cartesbancaires", "cartes-bancaires", "cb":
            if #available(iOS 11.2, *) {
                return .cartesBancaires
            }
            return nil
        case "eftpos":
            if #available(iOS 12.0, *) {
                return .eftpos
            }
            return nil
        case "elo":
            if #available(iOS 12.1.1, *) {
                return .elo
            }
            return nil
        case "girocard":
            if #available(iOS 14.0, *) {
                return .girocard
            }
            return nil
        case "mada":
            if #available(iOS 12.1.1, *) {
                return .mada
            }
            return nil
        case "mir":
            if #available(iOS 14.5, *) {
                return .mir
            }
            return nil
        case "bancomat":
            if #available(iOS 16.0, *) {
                return .bancomat
            }
            return nil
        case "bancontact":
            if #available(iOS 16.0, *) {
                return .bancontact
            }
            return nil
        default:
            return nil
        }
    }
    
    // MARK: - Button Building
    private func rebuildButton() {
        // Remove existing button
        payButton?.removeFromSuperview()
        
        // Create new button with current configuration
        let button = PKPaymentButton(paymentButtonType: buttonTypeValue, paymentButtonStyle: buttonStyleValue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = buttonCornerRadius
        button.addTarget(self, action: #selector(startApplePay), for: .touchUpInside)
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: buttonWidth),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        payButton = button
    }
    
    // MARK: - Apple Pay Flow
    @objc private func startApplePay() {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            showAlert("Error", "Apple Pay is not supported on this device")
            return
        }
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = supportedNetworksValue
        request.merchantCapabilities = merchantCapabilitiesValue
        request.countryCode = countryCode
        request.currencyCode = currencyCode
        request.paymentSummaryItems = paymentSummaryItems
        
        guard let viewController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            showAlert("Error", "Unable to create payment authorization")
            return
        }
        
        viewController.delegate = self
        
        // Use modern window scene API
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(viewController, animated: true)
        }
    }
    
    // MARK: - Alert Helper
    private func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alertController, animated: true)
        }
    }
    
    // MARK: - Token Handlers
    @objc func onTokenSuccess() {
        completion?(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    @objc func onTokenFailed() {
        let error = NSError(domain: "ApplePayError", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed to complete payment"])
        completion?(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.completion = completion
        
        var paymentDataString: String? = nil
        if let dataString = String(data: payment.token.paymentData, encoding: .utf8) {
            paymentDataString = dataString
        }
        
        onTokenReceived?([
            "transactionIdentifier": payment.token.transactionIdentifier,
            "paymentData": paymentDataString as Any,
            "paymentNetwork": payment.token.paymentMethod.network?.rawValue as Any,
            "paymentMethodDisplayName": payment.token.paymentMethod.displayName as Any,
            "paymentMethodType": Self.paymentMethodTypeToString(payment.token.paymentMethod.type)
        ])
    }
    
    private static func paymentMethodTypeToString(_ type: PKPaymentMethodType) -> String {
        switch type {
        case .debit:
            return "debit"
        case .credit:
            return "credit"
        case .prepaid:
            return "prepaid"
        case .store:
            return "store"
        case .eMoney:
            return "eMoney"
        default:
            return "unknown"
        }
    }
}
