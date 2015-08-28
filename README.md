# brine

A binary tree-based esoteric programming language. 

Unlike [brainfuck](http://esolangs.org/wiki/Brainfuck), the memory is laid out in the form of a binary tree; unlike [Arborealis](http://esolangs.org/wiki/Arborealis), [Treehugger](http://esolangs.org/wiki/Treehugger), and [V](http://esolangs.org/wiki/V), the nodes of the binary tree contain strings, which, as in [Underload](http://esolangs.org/wiki/Underload), can contain code to be executed.

## Commands

* **$** adds a parent node to the current node if one does not exist, attaching the current node as the left child and creating a right child.
* **%** adds two child nodes to the current node if they do not exist.
* **[]** stores whatever is between the brackets to the current node.
* **^** moves to the parent of the current node.
* **<** moves to the left child of the current node.
* **>** moves to the right child of the current node.
* **|** appends the data of the current node to its parent.
* **{** appends the data of the current node to its left child.
* **}** appends the data of the current node to its right child.
* **?** copies the current node to the clipboard.
* **!** replaces the current node with the contents of the clipboard.
* **=** jumps to the parent node if the current node's contents are equal to the parent node's contents.
* **~** executes the contents of the current node as Brine code.
* **,** reads input from the console and stores it to the current node.
* **.** prints the contents of the current node.

## Example programs

### Hello World

```
[Hello world!].
```

### Unary Fibonacci sequence calculator

```
%[1]..            Add children to initial node, then store 1 and print it twice
{}                Copy 1 to both child nodes
$^                Add a parent node (the loop node) and move to it
[                 Begin the main loop
  <[]             Clear the left child of the loop node (the 'A' node)
  <|^>|^.         Add the two children of the loop node to the 'A' node and print the result
  <?^^>!          Copy the left child of the 'A' node (the 'B' node) 
                  to the right child of the loop node
  ^$|^            Make a new copy of the loop node as the parent of the (old) loop node
  ~               Execute the new loop node
]~                Store the loop to the loop node and execute it
```

This builds an indefinitely-growing tree:

```
    ~         
   / \
 11A  O
 / \
1B  1

      ~  
     / \
  111A  11            
   / \ 
 11B  1 
 / \
1   1

       ~
      / \
  11111A 111   
     / \
  111B  11            
   / \ 
 11   1 
 / \
1   1
```

In each iteration of the loop, the loop node copies itself, overwrites itself with fibo(n-1) + fibo(n-2), and executes the copy of the loop node.

### Unary subtraction

Since there's no subtraction command, subtraction has to solve the equation `x = n + y` for n = [0,∞). Needless to say, this won't work if y > x.

```
[This program calculates x - y. Input x in unary.].,%<%>  
[Input y in unary.].,^<%<[1]
^^^>[^<<<|^^[]<|^>|^=^>~]^$^>[^<<<.]^<>~
```

This builds a tree like so:

```
        0
       / \
      x   @
     / \
   n+y  ~ 
   / \ 
  n   y
 / \
1   0
```

`~` contains the main loop, `[^<<<|^^[]<|^>|^=^>~]`: navigate from `~` to `1`, add `1` to `n`, replace `n+y` with the sum of `n` and `y`, and execute either `~` or `@` depending on whether `n+y` is equal to `x`. `@` contains `[^<<<.]`, which navigates from `@` to `n` and prints `n`. 

### Turing-completeness

Brine is Turing-complete by reduction from Underload. Using the left edge of the tree to simulate a stack:

* **(** = `$^[`
* **)** = `]`
* **:** = `$^[]<|^`
* **^** = `%>[<]^}[]>|^~`

Note that, for `^`, we have to prepend `<` to the contents of the cell before we execute it: Underload `^` pops the stack.

A Brine translation of the Underload [binary-counting Turing machine](http://oerjan.nvg.org/esoteric/underload/tmcount.disclaimed.ul) is provided as **bincount.bri**. Since the Underload source uses `S` and `~`, we provide Brine translations of those Underload commands as well:

* **S** = `.<`
* **~** = `%>[]^}>?^<>!^^[]<|[]>|^^`

We use `%>[]^}>?^` instead of `?` for reasons that are left as an exercise for the reader.