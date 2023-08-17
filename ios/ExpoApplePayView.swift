import ExpoModulesCore
import WebKit

// This view will be used as a native component. Make sure to inherit from `ExpoView`
// to apply the proper styling (e.g. border radius and shadows).
class ExpoApplePayView: ExpoView {
  let applePayView = WKWebView()

  required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext)
    clipsToBounds = true
    addSubview(applePayView)

    let url =  URL(string:"https://docs.expo.dev/modules/")!
    let urlRequest = URLRequest(url:url)
    applePayView.load(urlRequest)
  }

  override func layoutSubviews() {
    applePayView.frame = bounds
  }
}
