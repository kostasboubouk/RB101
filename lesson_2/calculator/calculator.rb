def prompt(message)
  Kernel.puts("=> #{message}")
end

def number?(num)
  integer?(num) || float?(num)
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  num.to_f.to_s == num
end

def operation_to_message(otm)
  case otm
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Dividing'
  end
end

prompt(MESSAGES['welcome'])

name = ''
loop do
  name = gets.chomp.capitalize
  if name.empty?
    prompt(MESSAGES['valid_name'])
  else
    break
  end
end

prompt("Hello #{name}!")

loop do
  number1 = ''
  loop do
    prompt(MESSAGES['first_number'])
    number1 = gets.chomp

    if number?(number1)
      break
    else
      prompt(MESSAGES['not_valid_number'])
    end
  end

  number2 = ''
  loop do
    prompt(MESSAGES['second_number'])
    number2 = gets.chomp
    
    if number?(number2)
      break
    else
      prompt(MESSAGES['not_valid_number'])
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
      1 = add
      2 = subtract
      3 = multiply
      4 = divide
  MSG
  prompt(operator_prompt)

  operation = ''
  loop do
    operation = gets.chomp

    if %w[1 2 3 4].include?(operation)
      break
    else
      prompt(MESSAGES['must_choose'])
    end
  end

  prompt("#{operation_to_message(operation)} the two numbers...")

  result = case operation
           when '1'
             number1.to_i + number2.to_i
           when '2'
             number1.to_i - number2.to_i
           when '3'
             number1.to_i * number2.to_i
           when '4'
             number1.to_f / number2.to_i
           end

  prompt("The result is #{result}!")

  prompt(MESSAGES['another'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')

end

prompt('Thank you for using the calculator. Good bye!')
