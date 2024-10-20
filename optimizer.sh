#!/bin/bash

# Declare Paths & Settings.
SYS_PATH="/etc/sysctl.conf"
PROF_PATH="/etc/profile"

# Ask Reboot
ask_reboot() {
    echo -ne "${YELLOW}Reboot now? (Recommended) (y/n): ${NC}"
    while true; do
        read choice
        echo 
        if [[ "$choice" == 'y' || "$choice" == 'Y' ]]; then
            sleep 0.5
            reboot
            exit 0
        fi
        if [[ "$choice" == 'n' || "$choice" == 'N' ]]; then
            break
        fi
    done
}

# SYSCTL Optimization
sysctl_optimizations() {
    ## Make a backup of the original sysctl.conf file
    cp $SYS_PATH /etc/sysctl.conf.bak

    echo 
    echo -e "${YELLOW}Default sysctl.conf file Saved. Directory: /etc/sysctl.conf.bak${NC}"
    echo 
    sleep 1

    echo 
    echo -e  "${YELLOW}Optimizing the Network...${NC}"
    echo 
    sleep 0.5

    sed -i -e '/fs.file-max/d' \
        -e '/net.core.default_qdisc/d' \
        -e '/net.core.netdev_max_backlog/d' \
        -e '/net.core.optmem_max/d' \
        -e '/net.core.somaxconn/d' \
        -e '/net.core.rmem_max/d' \
        -e '/net.core.wmem_max/d' \
        -e '/net.core.rmem_default/d' \
        -e '/net.core.wmem_default/d' \
        -e '/net.ipv4.tcp_rmem/d' \
        -e '/net.ipv4.tcp_wmem/d' \
        -e '/net.ipv4.tcp_congestion_control/d' \
        -e '/net.ipv4.tcp_fastopen/d' \
        -e '/net.ipv4.tcp_fin_timeout/d' \
        -e '/net.ipv4.tcp_keepalive_time/d' \
        -e '/net.ipv4.tcp_keepalive_probes/d' \
        -e '/net.ipv4.tcp_keepalive_intvl/d' \
        -e '/net.ipv4.tcp_max_orphans/d' \
        -e '/net.ipv4.tcp_max_syn_backlog/d' \
        -e '/net.ipv4.tcp_max_tw_buckets/d' \
        -e '/net.ipv4.tcp_mem/d' \
        -e '/net.ipv4.tcp_mtu_probing/d' \
        -e '/net.ipv4.tcp_notsent_lowat/d' \
        -e '/net.ipv4.tcp_retries2/d' \
        -e '/net.ipv4.tcp_sack/d' \
        -e '/net.ipv4.tcp_dsack/d' \
        -e '/net.ipv4.tcp_slow_start_after_idle/d' \
        -e '/net.ipv4.tcp_window_scaling/d' \
        -e '/net.ipv4.tcp_adv_win_scale/d' \
        -e '/net.ipv4.tcp_ecn/d' \
        -e '/net.ipv4.tcp_ecn_fallback/d' \
        -e '/net.ipv4.tcp_syncookies/d' \
        -e '/net.ipv4.udp_mem/d' \
        -e '/net.ipv6.conf.all.disable_ipv6/d' \
        -e '/net.ipv6.conf.default.disable_ipv6/d' \
        -e '/net.ipv6.conf.lo.disable_ipv6/d' \
        -e '/net.unix.max_dgram_qlen/d' \
        -e '/vm.min_free_kbytes/d' \
        -e '/vm.swappiness/d' \
        -e '/vm.vfs_cache_pressure/d' \
        -e '/net.ipv4.conf.default.rp_filter/d' \
        -e '/net.ipv4.conf.all.rp_filter/d' \
        -e '/net.ipv4.conf.all.accept_source_route/d' \
        -e '/net.ipv4.conf.default.accept_source_route/d' \
        -e '/net.ipv4.neigh.default.gc_thresh1/d' \
        -e '/net.ipv4.neigh.default.gc_thresh2/d' \
        -e '/net.ipv4.neigh.default.gc_thresh3/d' \
        -e '/net.ipv4.neigh.default.gc_stale_time/d' \
        -e '/net.ipv4.conf.default.arp_announce/d' \
        -e '/net.ipv4.conf.lo.arp_announce/d' \
        -e '/net.ipv4.conf.all.arp_announce/d' \
        -e '/kernel.panic/d' \
        -e '/vm.dirty_ratio/d' \
        -e '/^#/d' \
        -e '/^$/d' \
        "$SYS_PATH"

    ## Add new parameters.
    cat <<EOF >> "$SYS_PATH"
# New settings...
EOF

    sudo sysctl -p
    echo -e "${GREEN}Network is Optimized.${NC}"
}

# System Limits Optimizations
limits_optimizations() {
    echo -e "${YELLOW}Optimizing System Limits...${NC}"
    ## Clear old ulimits
    sed -i '/ulimit -c/d' $PROF_PATH
    # Clear other ulimits...

    ## Add new ulimits
    echo "ulimit -c unlimited" | tee -a $PROF_PATH
    echo "ulimit -d unlimited" | tee -a $PROF_PATH
    # Add more ulimits...

    echo -e "${GREEN}System Limits are Optimized.${NC}"
}

# Main function
hawshemi_script() {
    clear

    # Ask the user if they want to optimize the system
    echo -ne "${YELLOW}Do you want to optimize the system? (y/n): ${NC}"
    read choice
    if [[ "$choice" != 'y' && "$choice" != 'Y' ]]; then
        echo -e "${RED}Optimization cancelled.${NC}"
        return
    fi

    # Get the operating system name
    os_name=$(lsb_release -is)

    # Check if the operating system is Ubuntu
    if [ "$os_name" == "Ubuntu" ]; then
        echo -e "${GREEN}The operating system is Ubuntu.${NC}"
        sleep 1
        sysctl_optimizations
        limits_optimizations
        ask_reboot
    else
        echo -e "${RED}The operating system is not Ubuntu.${NC}"
    fi
}

# Run the script
hawshemi_script
