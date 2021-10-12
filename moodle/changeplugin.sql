UPDATE user SET plugin='mysql_native_password' WHERE user='root';
FLUSH PRIVILEGES;
exit
