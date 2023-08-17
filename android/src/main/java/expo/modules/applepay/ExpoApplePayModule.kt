package expo.modules.webview

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class ExpoApplePayModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoApplePay")

    View(ExpoApplePay::class) {}
  }
}