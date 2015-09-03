require './api_utils'

include ApiUtils

class Data
	
	def initialize
		@hosts = ApiUtils.get_hosts
	end
	
end