module WindowsDns

	private

	def get_windows_default_routes
		default_routes = []
		default_route_interfaces = []

		routes = `route print`
		active_routes = routes.split("=======================================================================")[3]
		active_routes = active_routes.split("\n")
		active_routes.each { |route| default_routes.push(route) if route.include? " 0.0.0.0 " }



		default_routes.each do |route|
			default_route = route.gsub(/\s+/, ' ')
			default_route = route.split(" ")
			default_route_interfaces.push({interface: default_route[default_route.length - 2], metric: default_route[default_route.length - 1].to_i})
		end

		return default_route_interfaces.sort_by { |interface, metric| metric }.reverse
	end

	def get_windows_connected_interfaces
		# Get Connected Interfaces and their names
		interfaces = `netsh interface show interface`
		connected_interfaces = []
		interfaces = interfaces.split("\n")

		interfaces.each { |line| connected_interfaces.push(line) if line.include? "Connected" }

		connected_interface_names = []

		connected_interfaces.each do |interface|
			data = interface.split("      ")
			connected_interface_names.push(data[3])
		end
		
		return connected_interface_names
	end

	def get_interfaces_data(interface_names)
		interface_data = [] 							# Relevant interface data will be placed here
		interface_dump = `netsh int ip show config`		# A dump of interface data from the command left
		interfaces = interface_dump.split("\n\n")		# Place each interface dump into a seperate element in an array
		interfaces.each do |interface|					# Go through each interface in the array
			interface_config = interface.split("\n")	# Place each line in the interface data into seperate elements in an array
			
			# If the interface is in our interface names list, grab the data and place it in the interface_data array
			interface_names.each do |interface_name|
				if interface_config[0].include? interface_name.strip
				
					# IP Address will be in ip_data
					ip_data = interface_config[2]
					ip_data = ip_data.gsub(/\s+/, ' ')
					ip_data.slice! "IP Address: "
					ip_data.strip!
					
					# List of name servers into an array
					nameserver_data = []
					config_nameserver_index = nil # index in the interface config where nameserver data exists
					interface_config.each_with_index do |config, index|
						config_nameserver_index = index if config.include? "DNS"
					end
					dns = interface_config[config_nameserver_index]
					dns = dns.gsub(/\s+/, ' ')
					dns.slice! "DNS servers configured through DHCP: "
					dns.slice! "Statically Configured DNS Servers:"
					dns.strip!
					nameserver_data.push(dns)
					if interface_config[config_nameserver_index + 1].include? "                                          "
						nameserver_data.push(interface_config[config_nameserver_index + 1].strip)
					end
					if interface_config[config_nameserver_index + 2].include? "                                          "
						nameserver_data.push(interface_config[config_nameserver_index + 2].strip)
					end
					
					interface_data.push({name: interface_name.strip, ip_address: ip_data, nameservers: nameserver_data})
					
				end
			end
		end
		return interface_data
	end
	
	public

	def get_windows_nameservers
		# Retrieve all connected interfaces
		connected_interfaces = get_windows_connected_interfaces
		# Get IP and nameserver data for those interfaces
		data = get_interfaces_data(connected_interfaces)
		# Retrieve the first default route
		default_routes = get_windows_default_routes
		default_route = default_routes.first
		# Marry the first default route and the appropriate interface data. This is likely the active link
		active_interface = data.find { |k| k[:ip_address] == default_route[:interface]}
		return active_interface[:nameservers]
	end
end