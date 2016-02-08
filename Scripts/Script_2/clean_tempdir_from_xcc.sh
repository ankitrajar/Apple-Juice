#!/usr/bin/expect
    set ip [lindex $argv 0];
    set user [lindex $argv 1];
    set user_pass [lindex $argv 2];
    set su_user [lindex $argv 3];
    set su_user_pass [lindex $argv 4];
    set tempdir [lindex $argv 5];

spawn ssh $user@$ip
expect {
    "*yes/no*" {
        send "yes\r"
        exp_continue
    }

    "assword:" {
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
send "rm -rf $tempdir\r";
expect "*#"
send "exit\r";
expect "*>"
send "exit\r";
expect eof
exit

