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

	protected

	def is_left_child?
		return self.parent.left_child == self
	end

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

def brine(src)
	loc = 0
	register = nil
  root_node = current_node = Node.new
  idx = 0

  # can't just use each_char because stuff in brackets needs to be skipped
  until idx == src.length
  	char = src[idx].chr
  	case char
  	when "$"
  		current_node.add_parent
  	when "%"
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
  			else
  				bracket_depth += 1 if src[i].chr == "["
  				puts src[i].chr
  				buffer << src[i].chr
  			end
  		end
  		current_node.value = buffer
  		idx = i
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
			register = current_node.deep_dup
		when "!"
			current_node.parent.overwrite_child(register)
		when "="
			current_node = parent_node if current_node.value == parent_node.value
		when "~"
			# this could be optimized, since loops are [...~]~
			# I bet this won't work
			brine(current_node.value.dup)
		when ","
			current_node.value = gets.chomp
		when "."
			puts current_node.value
  	end

  	idx += 1
  end
end