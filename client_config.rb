require 'yaml'
require './api_utils'

include ApiUtils

class ClientConfig

	attr_accessor :polling_interval, :refresh_interval
	
	def initialize
		#response = Net::HTTP.get("https://uptime-server-swillett.c9.io/api/v1/clients?#{client.id}")
		
		@polling_interval = 3
		@refresh_interval = 10
		#@nameservers
		
		#YAML.load('config.yml')
		#config = {
		#	name: config['client']['name'],
		#	hash: config['client']['hash'],
		#	token: config['client']['token']
		#}
	end
	
	def initialized?
		true
	end
	
end