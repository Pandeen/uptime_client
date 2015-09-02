require 'yaml'

module ConfigUtils
	
	def initialize
		response = Net::HTTP.get("https://uptime-server-swillett.c9.io/api/v1/clients?#{client.id}")
	end
	
	def read_config_file
		YAML.load('config.yml')
		name = config['client']['name']
		hash = config['client']['hash']
		token = config['client']['token']
	end
	
end