#ifndef FLUTTER_PLUGIN_FLUTTER_EASY_BARRAGE_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_EASY_BARRAGE_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _FlutterEasyBarragePlugin FlutterEasyBarragePlugin;
typedef struct {
  GObjectClass parent_class;
} FlutterEasyBarragePluginClass;

FLUTTER_PLUGIN_EXPORT GType flutter_easy_barrage_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void flutter_easy_barrage_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_FLUTTER_EASY_BARRAGE_PLUGIN_H_
