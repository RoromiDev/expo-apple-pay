import { ViewProps } from "react-native";
import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";

export type OnTokenReceived = {
  transactionIdentifier: string;
  paymentData: string;
  paymentNetwork: string;
};

export type Props = {
  merchantIdentifier: string;
  countryCode: string;
  currencyCode: string;
  amount: number;
  onTokenReceived?: (event: { nativeEvent: OnTokenReceived }) => void;
} & ViewProps;

const NativeView: React.ComponentType<Props> =
  requireNativeViewManager("ExpoApplePay");

const ExpoApplePay = React.forwardRef<React.ComponentType<Props>, Props>(
  (props, ref) => {
    return <NativeView {...props} ref={ref} />;
  }
);

export default ExpoApplePay;
