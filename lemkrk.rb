require 'bundler/setup'
require 'gaminator'

class Map
	attr_reader :x,:y,:land

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

	def is_death_zone? x,y
		x< 0 or y<0 or y>@h or x>@w 
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

	def initialize x,y, map, color, game
		@game = game
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

	def is_alive?
		@direction!=:rescued && @direction!=:killed
	end

	def work
		walk unless @direction == :killed 
	end 

	def walk 
		
		if @map.is_empty? @x,@y+1
			@old_dir = @direction unless @direction == :down
			@direction = :down  
		elsif @direction ==:down
			@direction = @old_dir 
		end 

		r = get_next_field
		
		if @map.is_death_zone? r[0],r[1]
			@direction =:killed
		end 

		if empty_field?(r[0],r[1])
			@x = r[0]
			@y = r[1]
		else
			change_dir 
		end 

		if @map.is_exit? @x,@y
			@direction = :rescued
		end 

	end 

	def empty_field? x,y
		@map.is_empty?(x,y) and !@game.is_colliding_with_lemming?(x,y)
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

class Block
  attr_accessor :x, :y

  def initialize x,y,vert,len
    @x = x
    @y = y
    @len = len
    text = "*" * len
    @vert = vert
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

  def work(game)
    xx = @x
    yy = @y
    land = game.mapobj.land

    @len.times do
      if game.is_colliding_with_lemming? xx, yy 
        return false
      end
    end


    @len.times do

      if (land[yy][xx] == '#')
        if land[yy][xx] != '@'
          land[yy][xx] = ' '
        end
      else
        land[yy][xx] = '#'
      end

      if @vert
        yy += 1
      else
        xx += 1
      end
    end

    return true
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
	attr_reader :width, :height, :mapobj

	def initialize w,h 
		@mapobj = Map.new w,h
		@lemmings = [ Leming.new(2,1,@mapobj,Curses::COLOR_GREEN,self),Leming.new(8,1,@mapobj,Curses::COLOR_RED,self) ]
          @block = BlockGenerator.random_block
          @exit_message = "ala"
	end 

	def objects
		[@mapobj, @lemmings.select {|x| x.is_alive?}, @block].flatten!
	end

	def input_map 
		{
			?w => :m_up, 
			?s => :m_down,
			?a => :m_left,
			?d => :m_right,
                        ?k => :m_action,
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

        def m_action
          if @block.work(self)
            @block = BlockGenerator.random_block
          end
        end


	def tick 
		process_lemmings
	end 

	def exit_message
	   @exit_message
	end 

	def textbox_content
		a =0 
		@lemmings.each do |l|
			a=a+1 if l.direction != :rescued 
		end 
		"live "+a.to_s + "  rescued  " +(@lemmings.count - a).to_s
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

	def is_colliding_with_lemming? x,y
		res = false 
		@lemmings.each do |l|
			res = true if l.x == x and l.y==y and l.is_alive?
		end 
		res
	end 
end 



Gaminator::Runner.new(LemKRK).run

