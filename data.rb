require './api_utils'

include ApiUtils

class ClientData
	
	def initialize
		@hosts = [
			{ id: '1', type: 'ICMP', node: 'google.com', port: '80', status: '', timeout: 1 },
			{ id: '2', type: 'ICMP', node: 'bing.com', port: '80', status: '', timeout: 1 },
			{ id: '3', type: 'ICMP', node: 'asdf.com', port: '80', status: '', timeout: 1 },
			{ id: '4', type: 'ICMP', node: 'ubuntu.com', port: '80', status: '', timeout: 1 },
			{ id: '5', type: 'ICMP', node: 'yahoo.com', port: '80', status: '', timeout: 1 }
		]
	end
	
	def hosts
		@hosts
	end
	
end