class Node
	attr_accessor :value
	attr_reader :parent, :left_child, :right_child
	@@num_nodes = 0

	def initialize(parent = nil)
		@parent = parent
		@left_child = nil
		@right_child = nil
		@value = ''
		@node_num = (@@num_nodes += 1)
	end

	def add_parent
		@parent ||= Node.new
		@parent.left_child = self
		@parent.right_child = Node.new(@parent)
	end

	def add_children
		@left_child ||= Node.new(self)
		@right_child ||= Node.new(self)
	end

	# should ! copy the entire node or just its value?
	# I'll have it copy the entire node, why not
	def deep_dup
		left_dup = right_dup = nil
		left_dup = self.left_child.deep_dup if self.left_child
		right_dup = self.right_child.deep_dup if self.right_child
		dup = Node.new
		dup.add_left_child(left_dup) if left_dup
		dup.add_right_child(right_dup) if right_dup
		dup.value = self.value
		dup
	end

	# the ! operation
	def overwrite_child(new_node, left)
		if left
			self.add_left_child(new_node)
		else
			self.add_right_child(new_node)
		end
	end

	def to_s
		(value == "" ? "No value" : value) + " \##{@node_num}"
	end

	def is_left_child?
		return self.parent.left_child == self
	end

	protected

	def add_left_child(node)
		self.left_child = node
		node.parent = self
	end

	def add_right_child(node)
		self.right_child = node
		node.parent = self
	end

	attr_writer :parent, :left_child, :right_child
end

def brine(src, debug = false, current_node = Node.new, register = nil)
	loc = 0
  idx = 0

  # can't just use each_char because stuff in brackets needs to be skipped
  until idx == src.length
  	puts "The current node is #{current_node}. \t\
Its parent is #{current_node.parent ? current_node.parent : 'nonexistent'}. \t\
Its left child is #{current_node.left_child ? current_node.left_child : 'nonexistent'}. \t\
Its right child is #{current_node.right_child ? current_node.right_child : 'nonexistent'}." if debug
  	char = src[idx].chr
  	puts src if debug
  	puts " " * idx + "^" if debug
  	case char
  	when "$"
  		puts "Adding parent." if debug
  		current_node.add_parent
  	when "%"
  		puts "Adding children." if debug
  		current_node.add_children
  	when "["
  		# an unmatched [ will dump everything to the end of the program into the node
  		bracket_depth = 0
  		i = idx
  		buffer = ""
  		until i == src.length || bracket_depth == -1
  			i += 1
  			if src[i].chr == "]"
  				bracket_depth -= 1
  			  buffer << src[i].chr unless bracket_depth < 0 # TODO
  			else
  				bracket_depth += 1 if src[i].chr == "["
  				buffer << src[i].chr
  			end
  		end
  		current_node.value = buffer
  		puts "Storing value #{buffer}." if debug
  		idx = i
  	when "^"
  		puts "Copying value to parent." if debug
  		current_node.parent.value += current_node.value
  	when "<"
  		puts "Copying value to left child." if debug
  		current_node.left_child.value += current_node.value
  	when ">"
  		puts "Copying value to right child." if debug
  		current_node.right_child.value += current_node.value
  	when "|"
  		puts "Moving to parent." if debug
  		current_node = current_node.parent
  	when "("
  		puts "Moving to left child." if debug
  		current_node = current_node.left_child
  	when ")"
			puts "Moving to right child." if debug
			current_node = current_node.right_child
		when "?"
			puts "Copying to clipboard." if debug
			register = current_node.deep_dup
		when "!"
			puts "Pasting from clipboard." if debug
			current_node.parent.overwrite_child(register, current_node.is_left_child?)
		when "="
			puts "If statement executed." if debug
			current_node = parent_node if current_node.value == parent_node.value
		when "~"
			puts "Executing code at current node." if debug
			# this could be optimized, since loops are [...~]~
			# I bet this won't work
			# why doesn't this take in the current_node? it ends up being nil
			brine(current_node.value, debug, current_node, register)
		when ","
			puts "Reading user input." if debug
			current_node.value = gets.chomp
		when "."
			puts "Printing." if debug
			puts current_node.value
  	end
  	idx += 1
  end
end
