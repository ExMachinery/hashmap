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
    hash_code
  end

  def index(hash_code)
    return @map[@map.index(hash_code)]
  end

  def set(key, value)
    hc = hash(key)
    if @map.include?(hc)
      if @map[index(hc)].key == key
        @map[index(hc)].next_node = Node.new(key, value)
      else
        @map[index(hc)].value = value
      end
    else
      @map.push(hc)
      @capacity = @capacity * 2 if @map.size > (@capacity * @load_factor)
      @map[index(hc)] = Node.new(key, value) 
    end
  end

  def get(key)
    hc = hash(key)
    return @map[index(hc)].value if @map.include?(hc)
    nil
  end

  def has?(key)
    return @map.include?(hash(key))
  end

  def remove(key)
    result = nil
    hc = hash(key)
    if @map.include?(hc)
      if @map[index(hc)].next_node == nil
        result = @map[index(hc)].value
        @map.delete_at(index(hc))
      else
        current = @map[index(hc)]
        done = nil
        until done
          if current.key == key
            result = current.value
            @map[index(hc)] = current.next_node
            done = true
          else
            done = true if current.next_node == nil
            current = current.next_node
          end
        end
      end
    end
    @capacity = @capacity/2 if @map.size < (@capacity * @load_factor)
    result
  end

  def length
    len = 0
    @map.each do |node|
      len += 1
      if node.next_node != nil
        done = nil
        current = node.next_node
        until done
          len += 1
          done = true if current.next_node == nil
          current = current.next_node
        end
      end
    end
    return len
  end

  def clear
    @map = []
    @capacity = 16
  end

  def keys
    array_of_keys = Array.new
    @map.each do |node|
      array_of_keys << node.key
      if node.next_node != nil
        done = nil
        current = node.next_node
        until done
          array_of_keys << node.key
          done = true if current.next_node == nil
          current = current.next_node
        end
      end
    end
    return array_of_keys
  end

  def values
    array_of_values = Array.new
    @map.each do |node|
      array_of_values << node.value
      if node.next_node != nil
        done = nil
        current = node.next_node
        until done
          array_of_values << node.value
          done = true if current.next_node == nil
          current = current.next_node
        end
      end
    end
    return array_of_values
  end

  def entries
    array_of_entries = Array.new
    @map.each do |node|
      array_of_entries << [node.key, node.value]
      if node.next_node != nil
        done = nil
        current = node.next_node
        until done
          array_of_entries << [node.key, node.value]
          done = true if current.next_node == nil
          current = current.next_node
        end
      end
    end
  end


end