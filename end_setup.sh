#!/bin/bash

check_shell()
{
    if [[ $SHELL != "/bin/zsh" ]]; then
        chsh -s /bin/zsh
    fi
}

arch_setup()
{
    groupadd adm
    groupadd manager
    groupadd epitech
    useradd -a -g adm -G epitech -m leslie
    useradd -a -g manager -G epitech -m romain
    pacman -Syu xfce4 lightdm nvim vim wget curl zsh
    localectl set-keymap fr
    localectl set-x11-keymap fr
    systemctl enable ssh
    cp data/host /etc/hosts
    cp data/ssh /etc/ssh/sshd_config
    cp data/sudo_arch /etc/sudoers
    check_shell
    cp data/zsh /home/leslie/.zshrc
    cp data/zsh /home/romain/.zshrc
}

debian_setup()
{
    groupadd pedago
    groupadd students
    groupadd epitech
    useradd -g pedago -G epitech -m hadrien
    useradd -g pedago -G epitech -m vincent
    useradd -g students -G epitech -m luc
    apt install cinnamon neovim wget curl zsh
    localectl set-keymap fr
    localectl set-x11-keymap fr
    systemctl enable ssh
    cp data/host /etc/hosts
    cp data/ssh /etc/ssh/sshd_config
    cp data/sudo_deb /etc/sudoers
    check_shell
    cp data/zsh /home/hadrien/.zshrc
    cp data/zsh /home/vincent/.zshrc
    cp data/zsh /home/luc/.zshrc
}

server_setup()
{
    cp data/host_server /etc/hosts
    cp data/ssh /etc/ssh/sshd_config
    apt install apache2 phpmyadmin mysql-server php-mysql
    systemctl enable apache2
    systemctl enable ssh
    systemctl enable php
    cp data/virtualhost_intra /etc/apache2/site-avaible/intra.conf
    cp data/virtualhost_intra_adm /etc/apache2/site-avaible/intra_adm.conf
    mkdir /var/www/intra/{intra,intra_adm}
    chown -R $USER:$USER /var/www/intra/
    a2dissite 000-default.conf
    cp data/intra.html /var/www/intra/intra/index.html
    cp data/intra_adm.html /var/www/intra/intra_adm/index.html
    a2ensite intra.conf
    a2ensite intra_adm.conf
    check_shell
    cp data/zsh /home/kwaegle/.zshrc

}


if [[ $(id -u) -ne 0 ]] ; then 
    echo "Please run as root" ; 
    exit 1 ; 
fi

PS3="Select the os to be configured: "
select os_type in "arch" "debian" "ubuntu server" "exit" 
do
    case $REPLY in
        1)
            arch_setup
            ;;
        2)
            debian_setup
            ;;
        3)
            server_setup
            ;;
        4)
            exit
            ;;
        *)
            echo "select valid option"
            ;;
    esac
done
