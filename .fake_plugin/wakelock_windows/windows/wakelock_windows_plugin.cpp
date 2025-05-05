#include "include/wakelock_windows/wakelock_windows_plugin.h"

// 这是一个空实现，只是为了满足插件结构要求
namespace {
  class WakelockWindowsPlugin : public flutter::Plugin {
   public:
    static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar) {
      auto channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "wakelock_windows",
          &flutter::StandardMethodCodec::GetInstance());
      auto plugin = std::make_unique<WakelockWindowsPlugin>();
      channel->SetMethodCallHandler(
          [plugin_pointer = plugin.get()](const auto &call, auto result) {
            plugin_pointer->HandleMethodCall(call, std::move(result));
          });
      registrar->AddPlugin(std::move(plugin));
    }

    WakelockWindowsPlugin() {}

    virtual ~WakelockWindowsPlugin() {}

   private:
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
      if (method_call.method_name().compare("enable") == 0) {
        result->Success();
      } else if (method_call.method_name().compare("disable") == 0) {
        result->Success();
      } else {
        result->NotImplemented();
      }
    }
  };
}

void WakelockWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  WakelockWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrar>(registrar));
} 