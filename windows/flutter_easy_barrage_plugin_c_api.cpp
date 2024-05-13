#include "include/flutter_easy_barrage/flutter_easy_barrage_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_easy_barrage_plugin.h"

void FlutterEasyBarragePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_easy_barrage::FlutterEasyBarragePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
