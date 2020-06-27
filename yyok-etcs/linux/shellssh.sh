
#!/bin/sh
function usage() {
        cat << EOF
        Usage ssh_connect ip [username] [password]
EOF
}
 
auto_login_ssh() {
        expect -c "set timeout -1;
        spawn ssh $user@$ip
        expect {
        yes/no {
                send \"yes\n\"
                expect password
                send \"$pass\n\"
        }
        password {send \"$pass\n\"}
        }
        interact;
        "
}
 
 
scp_file(){
        expect -c "
        spawn scp $pub $user@$ip:~
        expect {
        yes/no {
                send \"yes\n\"
                expect \"password\"
                send \"$pass\n\"
                }
        password {send \"$pass\n\"}
        }
        send \" cat ~/id_dsa.put >> ~/.ssh/authorized_keys\"
        interact;
        "
}
ssh_cmd() {
        echo $1
        expect -c "
        spawn ssh $user@$ip 
        expect {
        yes/no {
                send \"yes\n\"
                expect password
                send \"$pass\n\"
        }
        password {send \"$pass\n\"}
        }
        expect ]
        send \"$1\n\"
        expect ]
        send \"exit\n\"
        expect eof
        "
}
 
ip=$1
user=root
pass=pwd
if [ ! -z $2 ];then
        user=$2
fi
 
if [ ! -z $3 ];then
        pass=$3
fi
 
 
cd ~
 
sshpath=$PWD"/.ssh"
if [ ! -d $sshpath ];then
        mkdir $sshpath
fi
 
pub=$sshpath"/id_dsa.pub"
echo $pub
 
if [ ! -f $pub ]; then
        ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
fi
#auto_login_ssh
 
scp_file
ssh_cmd "cat ~/id_dsa.pub >> ~/.ssh/authorized_keys"