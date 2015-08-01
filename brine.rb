class Node
	attr_accessor :value
	attr_reader :parent, :left_child, :right_child

	def initialize(parent = nil)
		@parent = parent
		@left_child = nil
		@right_child = nil
		@value = ''
	end

	def add_parent
		@parent ||= Node.new
		@parent.left_child = self
		@parent.right_child = Node.new
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
	register = nil
  root_node = current_node = Node.new

  src.each_char do |char|
  	case char
  	when "$"
  		current_node.add_parent
  	when "%"
  		current_node.add_children
  	when "["
  		# look for matching ]
  	when "^"
  		current_node.parent.value = current_node.value
  	when "<"
  		current_node.left_child.value = current_node.value
  	when ">"
  		current_node.right_child.value = current_node.value
  	when "|"
  		current_node = current_node.parent
  	when "("
  		current_node = current_node.left_child
  	when ")"
			current_node = current_node.right_child
		when "?"
			register = current_node
		when "!"
			# TODO: deep dup
		when "="
			current_node = parent_node if current_node.value == parent_node.value
		when "~"
			# execute code in node
		when ","
			# pull from stdin
		when "."
			puts current_node.value
  	end
  end
end