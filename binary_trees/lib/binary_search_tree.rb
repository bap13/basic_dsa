require_relative './node'

class BinarySearchTree

  attr_reader :root_node, :count

  def initialize(root_node = nil)
    @root_node = root_node
    @count = 0
  end

  def push(data)
    new_node = Node.new(data)
    @count += 1
    if @root_node.nil?
      @root_node = new_node
    else
      current_node = @root_node
      loop do
        case current_node<=>new_node
        when 0..1
          if current_node.left.nil?
            current_node.left = new_node
            break
          else
            current_node = current_node.left
          end
        when -1
          if current_node.right.nil?
            current_node.right = new_node
            break
          else
            current_node = current_node.right
          end
        end
      end
    end
  end

  def include?(data)
    search_node = Node.new(data)
    if @root_node.nil?
      false
    else
      current_node = @root_node
      while !current_node.nil?
        case current_node<=>search_node
        when 0
          return true
          break
        when 1
          current_node = current_node.left
        when -1
          current_node = current_node.right
        end
      end
      return false
    end
  end

  def to_array
    array = []
    stack = []
    if @root_node.nil?
      array
    else
      stack << @root_node
      while current_node = stack.pop
        array << current_node.data
        if !current_node.right.nil?
          stack << current_node.right
        end
        if !current_node.left.nil?
          stack << current_node.left
        end
      end
    end
    array
  end

  def sort
    to_array.sort
  end

  def min
    min = nil
    current_node = @root_node
    if current_node.nil?
      min
    else
      until current_node.nil?
        min = current_node.data
        current_node = current_node.left
      end
    end
    min
  end

  def max
    max = nil
    current_node = @root_node
    if current_node.nil?
      max
    else
      until current_node.nil?
        max = current_node.data
        current_node = current_node.right
      end
    end
    max
  end

  def post_ordered
    output = []
    stack = []
    current_node = @root_node
    # return empty array if tree is empty
    if current_node.nil?
      output
    else
      # push root node onto stack
      stack << current_node
      # pop a node off the stack until the stack is empty
      while current_node = stack.pop
        # unshift the current_node data to the output array
        output.unshift(current_node.data)
        # push the left, then right children of current_node onto stack
        if !current_node.left.nil?
          stack << current_node.left
        end
        if !current_node.right.nil?
          stack << current_node.right
        end
      end
    end
    output
  end

  def min_height
    queue = []
    if @root_node.nil?
      0
    else
      queue << Q_item.new(@root_node, 1)
      while current_item = queue.shift
        node = current_item.node
        depth = current_item.depth
        if leaf_node?(node)
          return depth
        else
          if !node.left.nil?
            queue << Q_item.new(node.left, depth + 1)
          end
          if !node.right.nil?
            queue << Q_item.new(node.right, depth + 1)
          end
        end
      end
    end
  end

  def max_height
    stack = []
    max_height = 0

    unless @root_node.nil?
      stack << Q_item.new(@root_node, 1)

      while current_item = stack.pop
        node = current_item.node
        depth = current_item.depth

        max_height = depth if depth > max_height

        if !node.left.nil?
          stack << Q_item.new(node.left, depth + 1)
        end
        if !node.right.nil?
          stack << Q_item.new(node.right, depth + 1)
        end
      end
    end
    max_height
  end

  def balanced?
    return true if @root_node.nil?
    right_subtree_height =  if !@root_node.right.nil?
                              subtree = BinarySearchTree.new(@root_node.right)
                              subtree.max_height
                            else
                              0
                            end
    left_subtree_height =   if !@root_node.left.nil?
                              subtree = BinarySearchTree.new(@root_node.left)
                              subtree.max_height
                            else
                              0
                            end
    (right_subtree_height - left_subtree_height).abs <= 1
  end

  def balance!
    # dump all tree data into sorted array
    data = sort
    # set root to nil and count to 0
    reset
    # set middle element as the new root node
    push(data.delete_at(data.length/2))
    # push the rest of the data to the tree
    data.each { |i| push(i) }
  end

  private
  Q_item = Struct.new(:node, :depth)

  def leaf_node?(node)
    node.left.nil? && node.right.nil?
  end

  def reset
    @root_node = nil
    @count = 0
  end
end
