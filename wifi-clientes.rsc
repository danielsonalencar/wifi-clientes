#<INICIO DO SCRIPT>
#Criar bridge
/interface bridge
add name=bridge-vlan804

#Criar vlan
/interface vlan
add comment=WIFI-LIBERADO interface=bridge-Local name=vlan804 vlan-id=804

#Criar senha do WIFI CLIENTES
/interface wireless security-profiles
add authentication-types=wpa2-psk eap-methods="" management-protection=allowed mode=dynamic-keys name=profile-clientes supplicant-identity="" wpa2-pre-shared-key=wfpb2k21

#Criar rede WIFI CLIENTES
/interface wireless
add disabled=no keepalive-frames=disabled master-interface=wlan1 multicast-buffering=disabled \
name=wlan2 security-profile=profile-clientes ssid=$ssid wds-cost-range=0 \
wds-default-cost=0 wps-mode=disabled

#Criar o pool da rede WIFI CLIENTES
/ip pool
add name=dhcp_pool_clientes ranges=$pool

#Criar o dhcp da rede WIFI CLIENTES
/ip dhcp-server
add address-pool=dhcp_pool_clientes disabled=no interface=bridge-vlan804 \
lease-time=2h name=dhcp-WIFI-LIBERADO

#Criar o bridge port da interface VLAN e WLAN2
/interface bridge port
add bridge=bridge-vlan804 interface=wlan2
add bridge=bridge-vlan804 interface=vlan804

#Criar endereço da interface VLAN
/ip address
add address=$ipaddress1 interface=bridge-vlan804 network=$networkwifi

#Criar dhcp-server da rede WIFI CLIENTES 
/ip dhcp-server network
add address=$ipaddress0 comment=WIFI-LIBERADO dns-server=8.8.8.8,8.8.4.4 \
gateway=$gatewaywifi

#Regras de FIREWALL 
#Regra 1 
/ip firewall address-list
add address=$ipaddress0 list=IPs-WIFI-LIBERADO
#Regra 2 
/ip firewall mangle
add action=mark-routing chain=prerouting comment=routing-WIFI-LIBERADO \
dst-address=$networklan new-routing-mark=routing_WIFI-LIBERADO \
passthrough=yes src-address=$ipaddress0
#Regra 2
/ip firewall nat
add action=masquerade chain=srcnat comment=NAT-WIFI-LIBERADO dst-address=\
$networklan src-address=$ipaddress0

#Criação de rota default WIFI-LIBERADO
/ip route
add check-gateway=ping comment=DEFAULT-WIFI-LIBERADO distance=2 gateway=\
$nameinterfaceprovedor routing-mark=routing_WIFI-LIBERADO

#<FIM DO SCRIPT>
