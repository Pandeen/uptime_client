require './network_utils.rb'
require './client_config.rb'
require './data.rb'

include NetworkUtils

# Objects
semaphore = Mutex.new
config = ClientConfig.new
data = ClientData.new

# Refresh the client configuration and data every 10 seconds
config_thread = Thread.new {
	while true
		config.initialize
		data.initialize
		sleep 10
	end
}

while true

	if config.initialized?

		NetworkUtils.resolve_nodes(data.hosts)

		timer = Thread.new { 
			while config.initialized?
				sleep config[:refresh_interval]
				semaphore.synchronize {
					# Refresh configuration
					NetworkUtils.resolve_nodes( data.hosts.select { |host| host[:status] == 'dns_error'  } )
				}
			end
		}

		while config.initialized?
			sleep config[:polling_interval]
			semaphore.synchronize {
				NetworkUtils.ping_nodes(data.hosts)
				puts data.hosts
			}
		end
	else
		sleep 10
	end
	
end