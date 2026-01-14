# expo-apple-pay

An Expo module for integrating Apple Pay into your React Native applications.

## Installation

```bash
npm install expo-apple-pay
# or
yarn add expo-apple-pay
```

For bare React Native projects, run `npx pod-install` after installing.

## Usage

```tsx
import { ApplePayButton } from 'expo-apple-pay';

function PaymentScreen() {
  const handleTokenReceived = (event) => {
    const { transactionIdentifier, paymentData, paymentNetwork } = event.nativeEvent;
    // Send token to your server for processing
  };

  return (
    <ApplePayButton
      merchantIdentifier="merchant.com.yourapp"
      countryCode="US"
      currencyCode="USD"
      amount={99.99}
      paymentSummaryItems={[
        { label: 'Product', amount: 89.99 },
        { label: 'Shipping', amount: 10.00 },
        { label: 'Your Company', amount: 99.99 },
      ]}
      height={50}
      width={250}
      type="buy"
      buttonStyle="black"
      cornerRadius={8}
      supportedNetworks={['visa', 'masterCard', 'amex']}
      merchantCapabilities={['3ds']}
      onTokenReceived={handleTokenReceived}
    />
  );
}
```

## Props

### Required Props

| Prop | Type | Description |
|------|------|-------------|
| `merchantIdentifier` | `string` | Your Apple Pay merchant identifier (e.g., "merchant.com.yourapp") |
| `countryCode` | `string` | ISO 3166-1 alpha-2 country code (e.g., "US", "FR") |
| `currencyCode` | `string` | ISO 4217 currency code (e.g., "USD", "EUR") |
| `amount` | `number` | Total payment amount |
| `paymentSummaryItems` | `PaymentSummaryItem[]` | List of items displayed in the payment sheet |
| `height` | `number` | Button height in points |
| `width` | `number` | Button width in points |

### Optional Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `type` | `ApplePayButtonType` | `"plain"` | Button type - determines the text displayed |
| `buttonStyle` | `ApplePayButtonStyle` | `"black"` | Button style - determines the appearance |
| `cornerRadius` | `number` | `4` | Corner radius of the button |
| `supportedNetworks` | `PaymentNetwork[]` | `["visa", "masterCard"]` | Supported payment networks |
| `merchantCapabilities` | `MerchantCapability[]` | `["3ds"]` | Merchant capabilities |
| `onTokenReceived` | `function` | - | Callback when payment is authorized |

## Types

### ApplePayButtonType

Available button types:

| Value | Description | iOS Version |
|-------|-------------|-------------|
| `"plain"` | Apple Pay logo only | All |
| `"buy"` | "Buy with Apple Pay" | All |
| `"setUp"` | "Set Up Apple Pay" | All |
| `"inStore"` | "Apple Pay" (for in-store) | All |
| `"donate"` | "Donate with Apple Pay" | All |
| `"checkout"` | "Check out with Apple Pay" | All |
| `"book"` | "Book with Apple Pay" | All |
| `"subscribe"` | "Subscribe with Apple Pay" | All |
| `"continue"` | "Continue with Apple Pay" | All |
| `"reload"` | "Reload with Apple Pay" | iOS 14+ |
| `"addMoney"` | "Add Money with Apple Pay" | iOS 14+ |
| `"topUp"` | "Top Up with Apple Pay" | iOS 14+ |
| `"order"` | "Order with Apple Pay" | iOS 14+ |
| `"rent"` | "Rent with Apple Pay" | iOS 14+ |
| `"support"` | "Support with Apple Pay" | iOS 14+ |
| `"contribute"` | "Contribute with Apple Pay" | iOS 14+ |
| `"tip"` | "Tip with Apple Pay" | iOS 14+ |

### ApplePayButtonStyle

| Value | Description | iOS Version |
|-------|-------------|-------------|
| `"black"` | Black background, white text | All |
| `"white"` | White background, black text | All |
| `"whiteOutline"` | White with black outline | All |
| `"automatic"` | Adapts to dark/light mode | iOS 14+ |

### PaymentNetwork

Supported payment networks:

| Value | iOS Version |
|-------|-------------|
| `"visa"` | All |
| `"masterCard"` | All |
| `"amex"` | All |
| `"discover"` | All |
| `"chinaUnionPay"` | All |
| `"interac"` | All |
| `"jcb"` | All |
| `"maestro"` | iOS 12+ |
| `"electron"` | iOS 12+ |
| `"cartesBancaires"` | iOS 11.2+ |
| `"eftpos"` | iOS 12+ |
| `"elo"` | iOS 12.1.1+ |
| `"girocard"` | iOS 14+ |
| `"mada"` | iOS 12.1.1+ |
| `"mir"` | iOS 14.5+ |
| `"bancomat"` | iOS 16+ |
| `"bancontact"` | iOS 16+ |

### MerchantCapability

| Value | Description |
|-------|-------------|
| `"3ds"` | 3D Secure protocol |
| `"emv"` | EMV protocol |
| `"credit"` | Credit cards |
| `"debit"` | Debit cards |

### PaymentSummaryItem

```typescript
type PaymentSummaryItem = {
  label: string;      // Item name displayed to user
  amount: number;     // Price of the item
  type?: "final" | "pending";  // Default: "final"
};
```

### OnTokenReceived

The callback receives an event with:

```typescript
type OnTokenReceived = {
  transactionIdentifier: string;
  paymentData: string | null;
  paymentNetwork: string | null;
  paymentMethodDisplayName: string | null;
  paymentMethodType: "debit" | "credit" | "prepaid" | "store" | "eMoney" | "unknown";
};
```

## Handling Payment Results

After receiving the token via `onTokenReceived`, you need to process it on your server and then call either `onTokenSuccess()` or `onTokenFailed()` using a ref:

```tsx
import { useRef } from 'react';
import { ApplePayButton, ApplePayButtonRef } from 'expo-apple-pay';

function PaymentScreen() {
  const applePayRef = useRef<ApplePayButtonRef>(null);

  const handleTokenReceived = async (event) => {
    const { paymentData, transactionIdentifier } = event.nativeEvent;
    
    try {
      // Process payment on your server
      await processPaymentOnServer(paymentData);
      
      // Notify success
      applePayRef.current?.onTokenSuccess();
    } catch (error) {
      // Notify failure
      applePayRef.current?.onTokenFailed();
    }
  };

  return (
    <ApplePayButton
      ref={applePayRef}
      // ... other props
      onTokenReceived={handleTokenReceived}
    />
  );
}
```

## License

MIT
