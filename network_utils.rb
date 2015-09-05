require 'net/ping'
require 'net/dns'

module NetworkUtils
    
    def resolve_node(hostname)
		resolver = Net::DNS::Resolver.new
		resolver.nameservers = ['8.8.8.8']
        dns_answer = resolver.search(hostname)
        return dns_answer.answer[0].address.to_s if dns_answer.answer[0]
    end
    
    def resolve_nodes(hosts)
        threads = []
        hosts.each do |node|
            threads << Thread.new(node) do |host|
                if host[:type] == 'ICMP'
                    resolved = resolve_node(host[:node])
                    host[:node] = resolved if resolved
                    host[:status] = 'dns_error' unless resolved
                end
            end
        end
        threads.each { |thread|  thread.join }
    end
    
    def ping_node(hostname, timeout)
        return Net::Ping::ICMP.new(hostname, nil, timeout).ping?
    end
    
    def ping_http
        Net::Ping::HTTP.new(hostname).ping?
    end
    
    def ping_nodes(hosts)
        threads = []
        hosts.each do |node|
            threads << Thread.new(node) do |host|
                if host[:node] && host[:status] != 'dns_error'
                    if host[:type] == 'ICMP'
                        if ping_node(host[:node], host[:timeout])
                            host[:status] = 'online'
                        else
                            host[:status] = 'offline'
                        end
                    end
                end
            end
        end
        threads.each { |thread|  thread.join }
    end
    
end