require 'bundler/setup'
require 'gaminator'

class Map
	attr_reader :x,:y
	def initialize w,h
		@land = File.read('testmap.map').split("\n")
		@x = 0 
		@y = 0

		@w = @land[0].length
		@h = @land.length
	end 

	def texture
		@land 
	end


	def is_empty? x,y
		unless  x >= @w ||  y>=@h
			@land[y][x] == ' ' || @land[y][x] == '@'
		end 
	end 

	def is_exit? x,y 
		unless  x >= @w ||  y>=@h
			@land[y][x] == '@' 
		end
	end 


	def apply_block block 
	end 
end 

class Leming
	attr_reader :x,:y, :direction, :old_dir

	def initialize x,y, map, color 
		@map = map 
		@x = x 
		@y = y
		@direction = :right 
		@old_dir = :right 
		@color = color 
	end 

	def char
		'|'
	end 

	def color
		@color
	end

	def work 
		
		if @map.is_empty? @x,@y+1
			@old_dir = @direction unless @direction == :down
			@direction = :down  
		elsif @direction ==:down
			@direction = @old_dir 
		end 

		r = get_next_field
		if empty_field?(r[0],r[1])
			@x = r[0]
			@y = r[1]
		else
			change_dir 
		end 

		if @map.is_exit? @x,@y
			@direction = :stopped
		end 

	end 

	def empty_field? x,y
		@map.is_empty? x,y
	end 

	def change_dir
		case @direction
			when :right
				@direction = :left 
			when :left 
				@direction = :right
		end 
	end 

	def get_next_field
		case @direction
			when :right
				[@x+1, @y] 
			when :left
				[@x-1, @y] 
			when :down
				[@x, @y+1] 
			else
				[@x, @y]
		end 
	end
end

class LemKRK 
	attr_reader :width, :height

	def initialize w,h 
		@mapobj = Map.new w,h
		@lemmings = [ Leming.new(2,1,@mapobj,Curses::COLOR_GREEN ), Leming.new(8,1,@mapobj,Curses::COLOR_RED) ]
	end 

	def objects
		
		[@mapobj, @lemmings.filter {|x| x.direction!=:stopped}].flatten!
	end

	def input_map 
		{
			?w => m_up, 
			?s => m_down,
			?a => m_left,
			?d => m_right,
			?q => exit
		}
	end 


	def exit
		#Kernel.exit 
	end 

	def m_left 
	end 

	def m_right
	end 

	def m_down 
	end 

	def m_up 
	end 


	def tick 
		process_lemmings
	end 

	def exit_message
		'ala ma kota 123' 
	end 

	def textbox_content
		'test'
	end 

	def wait? 
		false 
	end 

	def sleep_time
		1.0/10.0 
	end 



	def process_lemmings 

		@lemmings.each do |l| 
			l.work
		end 

	end 
end 



Gaminator::Runner.new(LemKRK).run

