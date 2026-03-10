require_relative 'node'

class Hashmap
  attr_accessor :capacity, :load_factor, :map
  def initialize
    @capacity = 16
    @load_factor = 0.75
    @map = []
  end

  def hash(key) # REWRITE!
    hash_code = 0
    prime_number = 31
    key.each_char {|char| hash_code = prime_number * hash_code + char.ord}
    hash_code % @capacity
  end

  def grow_hashmap
    puts "Bananas!"
  end

  def shrink_hashmap
    puts "Bananas!"
  end

  def set(key, value)
    hc = hash(key)
    if !@map[hc]
      @map[hc] = Node.new(key, value)
    else
      current = @map[hc]
      until current.next_node == nil
        current = current.next_node
      end
      current.next_node = Node.new(key, value)
    end
    grow_hashmap if self.length > (@capacity * @load_factor)
  end

  def get(key)
    hc = hash(key)
    return nil if !@map[hc]
    return @map[hc].value if !@map[hc].next_node
    current = @map[hc]
    until current.next_node == nil || current.key == key
      current = current.next_node
    end
    return current.value if current.key == key
    nil
  end

  def has?(key) 
    @map[hash(key)] ? true : false
  end

  def remove(key)
    hc = hash(key)
    return nil if !@map[hc]
    result = nil
    if !@map[hc].next_node && @map[hc].key == key
      result = @map[hc].value  
      @map[hc] = nil
    else
      current = @map[hc]
      done = false
      until done
        done = true if current.next_node == nil
        if current.next_node.key == key
          result = current.next_node.value
          current.next_node = current.next_node.next_node
          done = true
        else
          current = current.next_node
        end
      end
    end
    shrink_hashmap if self.length < (@capacity * @load_factor)
    result
  end

  def clear
    @map = []
    @capacity = 16
  end

  def each_entry
    @map.each do |node|
      next if node == nil
      yield(node.key, node.value)
      if node.next_node != nil
        done = nil
        current = node.next_node
        until done
          yield(current.key, current.value)
          done = true if current.next_node == nil
          current = current.next_node
        end
      end
    end
    nil
  end

  def length
    len = 0
    self.each_entry {|key, val| len += 1}
    len
  end

  def keys
    result_array = []
    self.each_entry {|key, val| result_array << key}
    result_array
  end

  def values
    result_array = []
    self.each_entry {|key, val| result_array << val}
    result_array
  end

  def entries
    result_array = []
    self.each_entry {|key, val| result_array << [key, val] }
    result_array
  end
end