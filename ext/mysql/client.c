#include <mysql_ext.h>

VALUE cMysql2Client;
extern VALUE mMysql2;
struct nogvl_connect_args {
  MYSQL *mysql;
  const char *host;
  const char *user;
  const char *passwd;
  const char *db;
  unsigned int port;
};

static void *nogvl_connect(void *ptr) {
  struct nogvl_connect_args *args = ptr;
  MYSQL *client;

  client = mysql_real_connect(args->mysql, args->host,
                              args->user, args->passwd,
                              args->db, args->port, NULL, 0);

  return (void *)(client ? Qtrue : Qfalse);
}

static VALUE rb_mysql_connect(VALUE self, VALUE user, VALUE pass, VALUE host, VALUE port, VALUE database) {
  VALUE rv;
  struct nogvl_connect_args args;
  rv = (VALUE) rb_thread_call_without_gvl(nogvl_connect, &args, RUBY_UBF_IO, 0);
  return self;
}

void init_mysql2_client() {
  cMysql2Client = rb_define_class_under(mMysql2, "Client", rb_cObject);
  rb_global_variable(&cMysql2Client);
  rb_define_private_method(cMysql2Client, "connect", rb_mysql_connect, 8);
}