import { ConfigPlugin, withEntitlementsPlist } from "@expo/config-plugins";

const withApplePay: ConfigPlugin<{ merchantIdentifiers?: string[] }> = (
  config,
  { merchantIdentifiers = [] } = {}
) => {
  return withEntitlementsPlist(config, (config) => {
    config.modResults["com.apple.developer.in-app-payments"] = merchantIdentifiers;
    return config;
  });
};

export default withApplePay;