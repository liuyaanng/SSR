        echo -e "${Info} ShadowsocksR服务端 下载完成 !"
}
Service_SSR(){
        if [[ ${release} = "centos" ]]; then
                if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/service/ssr_centos -O /etc/init.d/ssr; then
                        echo -e "${Error} ShadowsocksR服务 管理脚本下载失败 !" && exit 1
                fi
                chmod +x /etc/init.d/ssr
                chkconfig --add ssr
                chkconfig ssr on
        else
                if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/service/ssr_debian -O /etc/init.d/ssr; then
                        echo -e "${Error} ShadowsocksR服务 管理脚本下载失败 !" && exit 1
                fi
                chmod +x /etc/init.d/ssr
                update-rc.d -f ssr defaults
        fi
        echo -e "${Info} ShadowsocksR服务 管理脚本下载完成 !"
}
# 安装 JQ解析器
JQ_install(){
        if [[ ! -e ${jq_file} ]]; then
                cd "${ssr_folder}"
                if [[ ${bit} = "x86_64" ]]; then
                        mv "jq-linux64" "jq"
                        #wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64" -O ${jq_file}
                else
                        mv "jq-linux32" "jq"
                        #wget --no-check-certificate "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32" -O ${jq_file}
                fi
                [[ ! -e ${jq_file} ]] && echo -e "${Error} JQ解析器 重命名失败，请检查 !" && exit 1
                chmod +x ${jq_file}
                echo -e "${Info} JQ解析器 安装完成，继续..."
        else
                echo -e "${Info} JQ解析器 已安装，继续..."
        fi
}
# 安装 依赖
Installation_dependency(){
        if [[ ${release} == "centos" ]]; then
                Centos_yum
        else
                Debian_apt
        fi
        [[ ! -e "/usr/bin/unzip" ]] && echo -e "${Error} 依赖 unzip(解压压缩包) 安装失败，多半是软件包源的问题，请检查 !" && exit 1
        Check_python
        #echo "nameserver 8.8.8.8" > /etc/resolv.conf
        #echo "nameserver 8.8.4.4" >> /etc/resolv.conf
        \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}
Install_SSR(){
        check_root
        [[ -e ${config_user_file} ]] && echo -e "${Error} ShadowsocksR 配置文件已存在，请检查( 如安装失败或者存在旧版本，请先卸载 ) !" && exit 1
        [[ -e ${ssr_folder} ]] && echo -e "${Error} ShadowsocksR 文件夹已存在，请检查( 如安装失败或者存在旧版本，请先卸载 ) !" && exit 1
        echo -e "${Info} 开始设置 ShadowsocksR账号配置..."

