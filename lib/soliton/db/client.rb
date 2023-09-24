module Soliton
  module DB
    class Client

      def initialize(opts = {})
        user     = opts[:username] || opts[:user]
        pass     = opts[:password] || opts[:pass]
        host     = opts[:host] || opts[:hostname]
        port     = opts[:port]
        database = opts[:database] || opts[:dbname] || opts[:db]
  
        user = user.to_s unless user.nil?
        pass = pass.to_s unless pass.nil?
        host = host.to_s unless host.nil?
        port = port.to_i unless port.nil?
        database = database.to_s unless database.nil?
  
        connect user, pass, host, port, database
      end
    end
  end
end
