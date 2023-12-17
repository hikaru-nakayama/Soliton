#include <mysql_ext.h>

VALUE mMysql2;

void Init_mysql2() {
  mMysql2 = rb_define_module("Mysql2");
  rb_global_variable(&mMysql2);
  init_mysql2_client();
}