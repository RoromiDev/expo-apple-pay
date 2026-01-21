import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";
import { ViewProps } from "react-native";

// MARK: - Button Type Options
export type ApplePayButtonType =
  | "plain"
  | "buy"
  | "setUp"
  | "inStore"
  | "donate"
  | "checkout"
  | "book"
  | "subscribe"
  | "reload" // iOS 14+
  | "addMoney" // iOS 14+
  | "topUp" // iOS 14+
  | "order" // iOS 14+
  | "rent" // iOS 14+
  | "support" // iOS 14+
  | "contribute" // iOS 14+
  | "tip" // iOS 14+
  | "continue";

// MARK: - Button Style Options
export type ApplePayButtonStyle =
  | "black"
  | "white"
  | "whiteOutline"
  | "automatic"; // iOS 14+ - adapts to dark/light mode

// MARK: - Supported Payment Networks
export type PaymentNetwork =
  | "visa"
  | "masterCard"
  | "amex"
  | "discover"
  | "chinaUnionPay"
  | "interac"
  | "jcb"
  | "maestro" // iOS 12+
  | "electron" // iOS 12+
  | "cartesBancaires" // iOS 11.2+
  | "eftpos" // iOS 12+
  | "elo" // iOS 12.1.1+
  | "girocard" // iOS 14+
  | "mada" // iOS 12.1.1+
  | "mir" // iOS 14.5+
  | "bancomat" // iOS 16+
  | "bancontact"; // iOS 16+

// MARK: - Merchant Capabilities
export type MerchantCapability = "3ds" | "emv" | "credit" | "debit";

// MARK: - Payment Summary Item
export type PaymentSummaryItem = {
  label: string;
  amount: number;
  type?: "final" | "pending";
};

// MARK: - Token Received Event
export type OnTokenReceived = {
  transactionIdentifier: string;
  paymentData: string | null;
  paymentNetwork: string | null;
  paymentMethodDisplayName: string | null;
  paymentMethodType:
  | "debit"
  | "credit"
  | "prepaid"
  | "store"
  | "eMoney"
  | "unknown";
};

// MARK: - Component Props
export type Props = {
  /** Apple Pay merchant identifier (e.g., "merchant.com.yourapp") */
  merchantIdentifier: string;

  /** ISO 3166-1 alpha-2 country code (e.g., "US", "FR") */
  countryCode: string;

  /** ISO 4217 currency code (e.g., "USD", "EUR") */
  currencyCode: string;

  /** Total payment amount */
  amount: number;

  /** List of items to display in the payment sheet */
  paymentSummaryItems: PaymentSummaryItem[];

  /** Button height in points */
  height: number;

  /** Button width in points */
  width: number;

  /** Button type - determines the text displayed (default: "plain") */
  type?: ApplePayButtonType;

  /** Button style - determines the appearance (default: "black") */
  buttonStyle?: ApplePayButtonStyle;

  /** Corner radius of the button (default: 4) */
  cornerRadius?: number;

  /** Supported payment networks (default: ["visa", "masterCard"]) */
  supportedNetworks?: PaymentNetwork[];

  /** Merchant capabilities (default: ["3ds"]) */
  merchantCapabilities?: MerchantCapability[];

  /** Callback when payment is authorized and token is received */
  onTokenReceived?: (event: { nativeEvent: OnTokenReceived }) => void;
} & ViewProps;

// Native view type with ref methods
type NativeViewRef = {
  onTokenSuccess: () => Promise<void>;
  onTokenFailed: () => Promise<void>;
};

const NativeView = requireNativeViewManager<Props>(
  "ExpoApplePay"
) as React.ComponentType<Props & { ref?: React.Ref<NativeViewRef> }>;

export type ApplePayButtonRef = NativeViewRef;

const ExpoApplePay = React.forwardRef<ApplePayButtonRef, Props>(
  (props, ref) => {
    const {
      type = "plain",
      buttonStyle = "black",
      cornerRadius = 4,
      supportedNetworks = ["visa", "masterCard"],
      merchantCapabilities = ["3ds"],
      ...rest
    } = props;

    return (
      <NativeView
        {...rest}
        type={type}
        buttonStyle={buttonStyle}
        cornerRadius={cornerRadius}
        supportedNetworks={supportedNetworks}
        merchantCapabilities={merchantCapabilities}
        ref={ref}
      />
    );
  }
);

ExpoApplePay.displayName = "ApplePayButton";

export default ExpoApplePay;
