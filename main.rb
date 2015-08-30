require './network_utils.rb'
include NetworkUtils

config = {
    polling_interval: 2,
    dns_timeout: 1,
    ping_timeout: 1,
}

hosts = [
    { id: '1', type: 'ICMP', node: 'google.com', port: '80', status: 'offline' },
    { id: '2', type: 'ICMP', node: 'test.com', port: '80', status: 'offline' }
]

NetworkUtils.resolve_nodes(hosts)

while true
    NetworkUtils.ping_nodes(hosts)
    NetworkUtils.resolve_nodes( hosts.select { |host| host[:status] == 'dns_error'  } )
    puts hosts
    sleep config[:polling_interval]
end