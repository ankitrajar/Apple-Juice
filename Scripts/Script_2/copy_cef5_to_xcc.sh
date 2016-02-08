#!/usr/bin/expect
    set ip [lindex $argv 0];
    set slot [lindex $argv 1];
    set user [lindex $argv 2];
    set user_pass [lindex $argv 3];
    set su_user [lindex $argv 4];
    set su_user_pass [lindex $argv 5];
    set tempdir [lindex $argv 6];
    set icc_ip_second_byte [lindex $argv 7];
   spawn ssh $user@$ip
expect {
    "*yes/no*" {
        send "yes\r"
        exp_continue
    }

    "*asswor*:" {
        send "$user_pass\r"
    }
}

expect "*>"
send "su\r";
expect "*asswor*:" 
send "$su_user_pass\r";
expect "*#"
send "cd /tmp\r";
expect "*#"
send "mkdir $tempdir\r";
expect "*#"
send "ncftpget -R -u$su_user -p$su_user_pass 127.$icc_ip_second_byte.1.$slot /tmp/$tempdir /etc/tejas/log/\r";
#expect "*#"
#send "cd $tempdir\r";
#expect "*#"
#send "ftp 127.$icc_ip_second_byte.1.$slot\r";
#expect "*):"
#send "root\r";
#expect "*asswor*" 
#send "$su_user_pass\r";
#expect "*>"
#send "cd /etc/tejas/log/\r";
#expect "*>" 
#send "prompt\r";
#expect "*>"       
#send "mget *\r";
#expect "*>" 
#send "exit\r";
expect "*#"
send "ls -l\r";
expect "*#"
send "exit\r";
expect "*>"       
send "exit\r";
expect eof

exit;
