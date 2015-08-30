require './network_utils.rb'
include NetworkUtils

semaphore = Mutex.new

config = {
    polling_interval: 2,
    refresh_interval: 15,
    dns_timeout: 1,
    ping_timeout: 1,
}

hosts = [
    { id: '1', type: 'ICMP', node: 'google.com', port: '80', status: 'offline' },
    { id: '2', type: 'ICMP', node: 'test.com', port: '80', status: 'offline' }
]

timer = Thread.new { 
    while true
        sleep config[:refresh_interval]
        semaphore.synchronize {
            puts "hi"
        }
    end
}

NetworkUtils.resolve_nodes(hosts)

while true
    sleep config[:polling_interval]
    semaphore.synchronize {
        NetworkUtils.ping_nodes(hosts)
        NetworkUtils.resolve_nodes( hosts.select { |host| host[:status] == 'dns_error'  } )
        puts hosts
    }
end