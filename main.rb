require './network_utils.rb'
require './config_utils.rb'

include NetworkUtils
include ConfigUtils

# Initialise configuration

=begin
config = {
    polling_interval: 3,
    refresh_interval: 15
}

hosts = [
    { id: '1', type: 'ICMP', node: 'google.com', port: '80', status: '', timeout: 1 },
    { id: '2', type: 'ICMP', node: 'bing.com', port: '80', status: '', timeout: 1 },
    { id: '3', type: 'ICMP', node: 'asdf.com', port: '80', status: '', timeout: 1 },
    { id: '4', type: 'ICMP', node: 'ubuntu.com', port: '80', status: '', timeout: 1 },
    { id: '5', type: 'ICMP', node: 'yahoo.com', port: '80', status: '', timeout: 1 }
]
=end

config = Thread.new {
	while true
		is_initialized = ConfigUtils.initialize
		sleep 10
	end
}

while true

	if is_initialized

		semaphore = Mutex.new

		NetworkUtils.resolve_nodes(hosts)

		timer = Thread.new { 
			while is_initialized
				sleep config[:refresh_interval]
				semaphore.synchronize {
					# Refresh configuration
					NetworkUtils.resolve_nodes( hosts.select { |host| host[:status] == 'dns_error'  } )
				}
			end
		}

		while is_initialized
			sleep config[:polling_interval]
			semaphore.synchronize {
				NetworkUtils.ping_nodes(hosts)
				puts hosts
			}
		end
	else
		sleep 10
	end
	
end