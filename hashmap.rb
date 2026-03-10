require_relative 'node'

class Hashmap
  attr_accessor :capacity, :load_factor, :map
  def initialize
    @capacity = 16
    @load_factor = 0.75
    @map = []
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char {|char| hash_code = prime_number * hash_code + char.ord}
    hash_code % @capacity
  end

  def resize_hashmap(instruction) 
    case instruction
    when :grow then @capacity = @capacity * 2
    when :shrink then @capacity = @capacity / 2
    end
    new_map = []
    self.each_entry {|key, val| new_map << [key, val]}
    @map = []
    new_map.each {|pair| set(pair[0], pair[1])}
  end

  def set(key, value)
    hc = hash(key)
    if !@map[hc]
      @map[hc] = Node.new(key, value)
    else
      current = @map[hc]
      done = nil
      until done
        if current.key == key
          current.value = value
          done = true
        elsif current.next_node
          current = current.next_node
        else
          current.next_node = Node.new(key, value)
          done = true
        end
      end
    end
    resize_hashmap(:grow) if self.length > (@capacity * @load_factor)
  end

  def temp2_key_check(key, instruction)
    result = nil
    hc = hash(key)
    if !@map[hc]
      result = false if instruction == :has
    else 
      current = @map[hc]
      until current.next_node == nil || current.key == key
        current = current.next_node
      end
      if current.key == key
        result = current.value if instruction == :get
        result = true if instruction == :has
      else
        result = false if instruction == :has
      end
    end
    result
  end

  def temp2_get(key)
    return key_check(key, :get)
  end

  def temp2_has?(key)
    return key_check(key, :has)
  end

  def find_node(key)
    hc = hash(key)
    return nil if !@map[hc]
    current = @map[hc]
    until current.next_node.nil? || current.key == key
      current = current.next_node
    end
    current&.key == key ? current : nil
  end

  def get(key)
    node = find_node(key)
    node ? node.value : nil
  end

  def has?(key)
    find_node(key) ? true : false
  end


  def temp_get(key)
    hc = hash(key)
    return nil if !@map[hc]
    current = @map[hc]
    until current.next_node == nil || current.key == key
      current = current.next_node
    end
    return current.value if current.key == key
    nil
  end

  def temp_has?(key) 
    hc = hash(key)
    return false if !@map[hc]
    current = @map[hc]
    until current.next_node == nil || current.key == key
      current = current.next_node
    end
    return true if current.key == key
    false
  end

  def remove(key)
    shrink_signal = @capacity / 2 if @capacity > 16
    hc = hash(key)
    return nil if !@map[hc]

    result = nil
      current = @map[hc]
      done = false
      until done
        done = true if current.next_node == nil
        if current.key == key
          result = current.value
          current.next_node ? @map[hc] = current.next_node : current = nil
          done = true
        elsif current.next_node.key == key
          result = current.next_node.value
          current.next_node = current.next_node.next_node
          done = true
        else
          current = current.next_node
        end
      end

    if shrink_signal
      resize_hashmap(:shrink) if self.length < shrink_signal
    end
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