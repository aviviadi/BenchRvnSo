init = function(args)
	depth = tonumber(args[1]) or 1	
	math.randomseed(os.time())
end

request = function()
	local reqs = {}

	for i=1, depth do
		reqs[i] = wrk.format(nil, "/databases/BenchmarkDB/docs?&id=temp/0000000000000".. math.random(900000)+100000 .."-A")
	end
	return table.concat(reqs)
end 
