//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import realm
import shared_preferences_macos
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  RealmPlugin.register(with: registry.registrar(forPlugin: "RealmPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
