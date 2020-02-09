#include "tenhourtime.c"
#include <libxfce4panel/xfce-panel-plugin.h>

static void constructor(XfcePanelPlugin *plugin);
XFCE_PANEL_PLUGIN_REGISTER(constructor);

struct updatedata {
  GtkTextBuffer *buffer;
  char *resstr;
  int previi;
};

gboolean updateTime(gpointer anydata) {
  struct updatedata *data = (struct updatedata *)anydata;
  GtkTextBuffer *buffer = data->buffer;

  struct tht_time sepertime = seperatetime(tenhourtime());

  char *resstr = data->resstr;
  // sprintf(resstr, "%02dLL %02dcc %02dii %02dqm", sepertime.LL, sepertime.cc,
  //         sepertime.ii, sepertime.qm);

  if (data->previi != sepertime.ii) {
    data->previi = sepertime.ii;
    sprintf(resstr, "%02dLL %02dcc %02dii", sepertime.LL, sepertime.cc,
            (sepertime.ii / 10) * 10);
    gtk_text_buffer_set_text(buffer, resstr, -1);
  }
  return TRUE;
}

static void constructor(XfcePanelPlugin *plugin) {
  GtkWidget *view = gtk_text_view_new();

  GtkTextBuffer *buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(view));

  gtk_text_buffer_set_text(buffer, "Hello, this is some text", -1);

  gtk_container_add(GTK_CONTAINER(plugin), view);

  gtk_widget_show_all(view);

  struct updatedata *data = malloc(sizeof(struct updatedata));
  data->resstr = (char *)malloc(100 * sizeof(char));
  data->buffer = buffer;
  data->previi = 0;

  g_timeout_add(10, updateTime, data);
}