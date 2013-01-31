require 'bundler/setup'
require 'gaminator'

class LemKRK 
	attr_reader :width, :height

	def initialize w,h 
	end 

	def objects
		[]
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
		Kernel.exit 
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

