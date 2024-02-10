###### Starting pseudo-code
Example:

Given a collection of integers.

Iterate through the collection one by one.
    - save the first value as the starting value.
    - for each iteration, compare the saved value with the current value.
    - if the saved value is greater, or it's the same
        - move to the next value in the collection
    - otherwise, if the current value is greater
        - reassign the saved value as the current value

After iterating through the collection, return the saved value.

###### Formal pseudo-code
Example:

START 

#Given a collection of integers called 'numbers'

SET iterator = 1
SET saved_number = value within numbers collection at space 1

WHILE iterator <= length of numbers
    SET current_number = value within numbers collection at space 'iterator'
    IF saved_number >= current_number
        go to the next iteration
    ELSE
        saved_number = current_number
    iterator = iterator + 1
PRINT saved_number

END

##############################################################################
Exercises:

1)
Given two integers.
Make and addition operation with the two integers and save the result into a variable.
######
START 
Given two integers.
SET result = integer1 + integer2
PRINT result
END

2)
Given a collection of strings
Merge the strings all together in a string without spaces.
And save the result in a variable
######
START
Given a collection of strings called 'arr'
SET new_arr = the strings all together without space
END

3)
Given a collection of integers
Create a new empty collection
Iterate through the collection one by one
Starting from the first element push every second element to the empty collection that we created 
######
START
Given a collection of integers called 'arr'
SET iterator = 0
SET new_arr = collection of integers from the first arr

WHILE iterator <= arr.length
    IF iterator.even?
        new_arr.push(arr[iterator])
    END
    iterator += iterator
END
        
