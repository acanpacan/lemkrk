require 'bundler/setup'
require 'gaminator'

class Map
	attr_reader :x,:y
	def initialize w,h
		@land = File.read('testmap.map').split("\n")
		@x = 0 
		@y = 0
	end 

	def texture
		@land 
	end


	def is_empty? x,y 
	end 

	def is_exit? x,y 
	end 

	def apply_block block 
	end 
end 

class Leming
	attr_reader :x,:y

	def initialize x,y
		@x = x 
		@y = y
	end 

	def char
		'|' 
	end 
end

class Block
  attr_accessor :x, :y

  def initialize x,y,vert,len
    @x = x
    @y = y
    text = "*" * len
    if vert 
      text = text.split('').map {|x| x}
    else
      text = [text]
    end
    @shape = text
  end

  def texture
    @shape
  end

  def work(map)
    
  end
end

class BlockGenerator
  
  def self.random_block
    len = rand(4) + 1
    vertical = rand(2) == 1

    Block.new(0,0,vertical,len)
  end
end

class LemKRK 
	attr_reader :width, :height

	def initialize w,h 
		@mapobj = Map.new w,h
		@lemmings = [ Leming.new(2,1), Leming.new(4,1) ]
                @block = BlockGenerator.random_block
	end 

	def objects
		[@mapobj, @lemmings, @block].flatten!
	end

	def input_map 
		{
			?w => :m_up, 
			?s => :m_down,
			?a => :m_left,
			?d => :m_right,
			?q => :exit
		}
	end 


	def exit
		Kernel.exit 
	end 

	def m_left
          @block.x = @block.x - 1
	end 

	def m_right
          @block.x = @block.x + 1
	end 

	def m_down 
          @block.y = @block.y + 1
	end 

	def m_up 
          @block.y = @block.y - 1
	end 


	def tick 
	end 

	def exit_message
		'ala ma kota 123' 
	end 

	def textbox_content
		'test'
	end 

	def wait? 
		true 
	end 

	def sleep_time
		1.0/60.0 
	end 
end 



Gaminator::Runner.new(LemKRK).run

