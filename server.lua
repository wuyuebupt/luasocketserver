local uv = require('luv')


local function create_server(host, port, on_connection)
	local server = uv.new_tcp()
	server:bind(host, port)
	server:listen(128, function(err)
		assert(not err, err)
		local client = uv.new_tcp()
		server:accept(client)
		on_connection(client)
	end)
	return server
end



local server = create_server("127.0.0.1", 9999, function (client)
	client:read_start(function (err, chunk)
		 assert(not err, err)
		 if chunk then
			 print(chunk)
			 client:write(chunk)
		 else
			 client:close()
		 end
	 end)
 end)

 print("TCP Echo serverr listening on port " .. server:getsockname().port)
 uv.run()


