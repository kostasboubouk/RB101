The meaning of an expression in Ruby is determined by what is called **operator precedence**. It's a set of rules that dictate how Ruby determines what **operands** each operator takes. Operands are simply values -- the results of evaluating expressions -- that are used by the operator. For most operators there are two operands; however, there are also 'unary' and 'ternary' operators that take one or three operands:
```ruby
2 + 5           # Two operands (2 and 5)
!true           # Unary: One operand (true)
value ? 1 : 2   # Ternary: Three operands (value, 1, 2)
```
Each operand can be the result of evaluating some other operator and its operands. Consider this expression.

```ruby
> 3 + 5 * 7
```
Here we have 2 operators (`+` and `*`), each of which takes 2 numbers as operands. However, there are only 3 numbers here. What does this expression evaluate to?
In an expression, operators with higher precedence are prioritized over those with lower precedence. In `3 + 5 * 7`, `*` has higher precedence than `+`, so `*` gets passed `5` and `7` as operands, which returns `35` as a result. Subsequently, `3` and `35` get passed to `+` for a final result of `38`. It's as tough Ruby inserted a pair of parentheses around `5 * 7`:
```ruby
> 3 + (5 * 7) # => 38
```
If we wanted to prioritize `3 + 5`, the solution is simple:
```ruby
(3 + 5) * 7 # => 56
```
The best way of thinking about precedence is, as a mechanism used by Ruby to determine which operands get passed to each operator. It's not the best practice to rely too much on precedence because it's easy to forget the order and get confused by an unexpected result. If you are using 2 or more different operators in an expression, use parentheses to explicity define the meaning. Also if there are multiple `=` operators evaluate right-to-left. An operator that has higher precedence than another is said to **bind** more tightly to its operands. In the expression `3 + 5 * 7`, the `*` operator binds more tightly to its operands, `5` and `7`, than does the `+` operator. Thus, `+` binds to `3` and the return value of `5 * 7` instead of `3` and `5`.

##### Evaluation Order
Precedence in Ruby is only part of the story; the other parts are either left-to-right evaluation, right-to-left evaluation, short-circuiting, and ternary expressions.
Example:
```ruby
def value(n)
    puts n 
    n
end

puts value(3) + value(5) * value(7)


# => 3
# => 5
# => 7
# => 38
```
Here the evaluation of the expressions is not done left-to-right because we can get the result `38` only if `value(5) * value(7)` gets evaluated first. The issue here is that operators like `+` and `*` need values that they can work with. Method invocations like `value(5)` and `value(7)` are not values. We can't invoke the `*` operator until we know what values those methods return. In an arithmetic expression, Ruby first goes through an expression left-to-right and evaluates everything it can without calling any operators.Thus, here it evaluates `value(3)`, `value(5)` and `value(7)` first, in that order. Only when it has those values does it deal with precedence and re-evaluate the result.

Right-to-left evaluation occurs when you do multiple assignments or multiple modifiers:
```ruby
a = b = c = 3
puts a if a == b if a == c
# Neither of them are good practice in Ruby.
```

The ternary operator(`?:`) and the short-circuit operators `&&` and `||` are a common source of unexpected behavior where precedence is concerned. Consider the following expressions:
```ruby
3 ? 1 / 0 : 1 + 2   # raises error ZeroDivisionError
5 && 1 / 0          # raises error ZeroDivisionError
nil || 1 / 0        # raises error ZeroDivisionError
```
If we modify things so that `1 / 0` isn't needed.
```ruby
nil ? 1 / 0 : 1 + 2     # 3
nil && 1 / 0            # nil
5 || 1 / 0              # 5
```
In all 3 cases, `1 / 0` never gets executed, even though operator precedence would suggest that it should be evaluated first. In the first expression, `1 / 0` isn't evaluated since it's the truthy operand for the `?:` - it only gets run when the value to the left of `?` is truthy. Instead, the code returns `3 (1 + 2)`. The other two expressions don't evaluate `1 / 0` due to short-circuiting. In all 3 expressions, this is simply the way Ruby works - it treats `?:`, `&&`, and `||` differently from other operators and doesn't evaluate subexpressions unless it needs them.

Another source of unexpected behavior occurs when you call methods with arguments in a ternary expression:
```ruby
true ? puts 'Hello' : puts 'Goodbye'    # raises a SyntaxError
false ? puts 'Hello' : puts 'Goodbye'   # raises a SyntaxError
```
This code raises SyntaxError since Ruby is unable to understand that `puts` and `'Hello'` go together, as do 'puts' and `'Goodbye'`. Instead, it expects a `:` immediately after the first `puts`, which makes no sense. The solution is to use parentheses; either of the following will work:
```ruby
true ? puts('Hello') : puts('Goodbye')      # => Hello
false ? (puts 'Hello') : (puts 'Goodbye')   # => Goodbye
```
Because we want the true and false clauses of a ternary expression to be as simple as possible, we can do this instead:
```ruby
puts(true ? 'Hello' : 'Goodbye')    # Hello
puts(false ? 'Hello' : 'Goodbye')   # Goodbye
```
##### Ruby's `tap` method
It's the Object instance method `tap`. It simply passes the calling object into a block, then returns that object. As the name suggests, tap is not unlike the tapping of a phone where the goal is to listen in to a conversation - to inspect the voice data 'flowing' along the phone line, and to then pass that data along uninterrupted and unchanged. That's the same effect that tap achieves by returning the object that calls it. The point is to look at the object, then pass it along.
```ruby
mapped_array = array.map { |num| num + 1 }

mapped_array.tap { |value| p value }    # => [2, 3, 4]
```
`array.map { |num| num + 1}` resolves to `[2, 3, 4]`, which then gets used to call `tap`. `tap` takes the calling object and passes it to the block argument, then returns that same object. Typically, you will do something like print the object inside that block.
```ruby
mapped_and_tapped = mapped_array.tap { |value| p 'hello'}   # 'hello'
mapped_and_tapped                                           # => [2, 3, 4]
```
On other use case this method is to debug intermediate objects in method chains. 
```ruby
(1..10)                     .tap { |x| p x }    # 1..10
.to_a                       .tap { |x| p x }    # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
.select {|x| x.even?}       .tap { |x| p x }    # [2, 4, 6, 8, 10]
.map {|x| x*x}              .tap { |x| p x }    # [4, 16, 36, 64, 100]
```
Here the transformation done and the resulting object at every step is now visible to us by just using `tap`.
