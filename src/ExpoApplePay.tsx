import { ViewProps } from "react-native";
import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";

export type Props = {
  url?: string;
} & ViewProps;

const NativeView: React.ComponentType<Props> =
  requireNativeViewManager("ExpoApplePay");

export default function ExpoApplePay(props: Props) {
  return <NativeView {...props} />;
}
