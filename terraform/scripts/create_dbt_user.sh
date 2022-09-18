#/bin/bash

usage() { echo "Usage: $0 [-u <username>] [-f <public-key>]" 1>&2; exit 1; }

while getopts "u:f:" flag
do
    case "${flag}" in
        u) 
	u=${OPTARG}
	if getent passwd $u > /dev/null 2>&1; then
	    echo "User exists, just updating the ssh public key"
	    sudo chsh -s /bin/bash $u 
	else
            echo "User does not exist, creating user and updating ssh key"
	    sudo useradd -m -d /home/${u}
	    sudo -u ${u} bash -c "yes '' | ssh-keygen -N '' > /dev/null"
	fi
	;;
        f) 
	f=${OPTARG}
	    sudo bash -c "cat ${f} >> /home/${u}/.ssh/authorized_keys"
	    sudo chown -R ${u}:${u} /home/${u}
	    sudo chmod 600 /home/${u}/.ssh/authorized_keys	
	    sudo chsh -s /bin/true $u 2> /dev/null
	;;
	*)
            usage
        ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${u}" ] || [ -z "${f}" ]; then
    usage
fi
