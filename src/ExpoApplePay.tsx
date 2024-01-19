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
  paymentSummaryItems: Array<any>;
  height: number;
  width: number;
  type: string;
  onTokenReceived?: (event: { nativeEvent: OnTokenReceived }) => void;
} & ViewProps;

const NativeView = requireNativeViewManager("ExpoApplePay");

const ExpoApplePay = React.forwardRef((props, ref) => {
  return <NativeView {...props} ref={ref} />;
});

export default ExpoApplePay;
