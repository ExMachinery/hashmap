require_relative 'hashmap'

test = Hashmap.new
test.set('apple', 'red')
test.set('banana', 'yellow')
test.set('carrot', 'orange')
test.set('dog', 'brown')
test.set('elephant', 'gray')
test.set('frog', 'green')
test.set('grape', 'purple')
test.set('hat', 'black')
test.set('ice cream', 'white')
test.set('jacket', 'blue')
test.set('kite', 'pink')
test.set('lion', 'golden')

# p test.keys
# p test.values
# p test.entries
# test.length

# test.has?('apple')
# test.get('apple')
# test.keys
test.remove('jacket')