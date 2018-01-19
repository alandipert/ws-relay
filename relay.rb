#!/usr/bin/env ruby

# Send lines from the input fifo to stdout
Thread.new {
	loop do
		STDOUT.write(File.open(ARGV[0], 'r').gets)
		STDOUT.flush
	end
}

# Send lines from stdin to the output fifo
Thread.new {
	loop do
		out = File.open(ARGV[1], 'w')
		out.write(STDIN.gets)
		out.flush
	end
}

sleep()
