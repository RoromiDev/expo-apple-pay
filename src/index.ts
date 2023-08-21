export { default as ApplePayButton, Props as ApplePayButtonProps } from './ExpoApplePay';
import ExpoApplePayModule from './ExpoApplePayModule';

export function onTokenSuccess() {
    ExpoApplePayModule.onTokenSuccess()
}

export function onTokenFailed() {
    ExpoApplePayModule.onTokenFailed()
}