import ExpoModulesCore

// This view will be used as a native component. Make sure to inherit from `ExpoView`
// to apply the proper styling (e.g. border radius and shadows).
class ExpoApplePayView: ExpoView {
  let onTokenReceived = EventDispatcher()
  let applePayView = ApplePayButton()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
    addSubview(applePayView)
    applePayView.setEventDispatcher(onTokenReceived)
  }

  override func layoutSubviews() {
    applePayView.frame = bounds
  }
}
