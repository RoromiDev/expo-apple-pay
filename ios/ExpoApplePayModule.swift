import ExpoModulesCore

public class ExpoApplePayModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoApplePay")

    View(ExpoApplePayView.self) {
      Prop("url") { (view, url: URL) in
        if view.applePayView.url != url {
          let urlRequest = URLRequest(url: url)
          view.applePayView.load(urlRequest)
        }
      }
    }
  }
}