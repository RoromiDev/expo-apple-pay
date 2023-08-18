import { ViewProps } from "react-native";
import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";

export type OnTokenReceived = {
  token: string;
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

export default function ExpoApplePay(props: Props) {
  return <NativeView {...props} />;
}
