class Node
	attr_accessor :value
	attr_reader :parent, :left_child, :right_child

	def initialize(parent = nil)
		@parent = parent
		@left_child = nil
		@right_child = nil
	end

	def add_parent
		@parent ||= Node.new
		@parent.left_child = self
	end

	def add_children
		@left_child ||= Node.new(self)
		@right_child ||= Node.new(self)
	end

	protected

	attr_writer :parent, :left_child, :right_child
end

def brine(src)
	loc = 0
	bracket_depth = 0
	register = 0
end