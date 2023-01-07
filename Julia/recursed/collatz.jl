#!/usr/bin/julia

#Copies value of passed in argument to preform collatz on
num = 0

#Length of each collatz sequence
collatzLength = 0

#These temp variables are used for swapping key-value pairs
tempKey1 = 0
tempVal1 = 0

tempKey2 = 0
tempVal2 = 0

#Keeps track of index of the minimum integer when sorting by key value
minIndex = 0

upperBound = 0

#Checks if collatz value is equal to any other in the array
equalFlag = 0


#Pre-Condition: A positive integer is passed in
#Post-Condition: Collatz sequence is preformed on the passed in integer, adding the integer to a an array
#of the 10 smallest integers with the longest collatz sequences in the specified range if that integer has 
#a longer sequence than one of the 10 integers in the array
function collatz(key)

	global collatzLength

	#Set num to the passed in integer
	num = key

	#Recursively preforms calculations on num until it reaches 1, as per the collatz conjecture
	if( num != 1)
		#If num is positive, divide it by 2
		if(num % 2 == 0)
			num = num/2
			collatzLength = collatzLength + 1
		#Else, multiply it by 3 and add 1, guaranteeing an even number, so then divide by 2
		else
			num = (num * 3) + 1
			num = num/2
			collatzLength = collatzLength + 2
		end

		collatz(num)

	end	
end

#Pre-Condition: Called immediately after a collatz sequence length is calculated
#Post-Condition: The previously calculated collatz sequence length is compared to an array containing the previous 10
#longest sequences, and is added to the array if it has a longer sequence than one of the values in the array, ejecting the 
#shortest sequence.
function compare(key)

	global collatzLength

	equalFlag = 0

	#If the same collatz length can be found in the array, don't duplicate the value
	for l in 1:10
		if(collatzLength == collatzArr[l, 2])
			equalFlag = 1
			break
		end
	end

	#After the sequence length for the passed in integer is calculated, check the 10 values being kept track of
	#to see if the new integer has a longer sequence than one of them. If so, add the new integer to the first index in
	#the array where it has a longer sequence, and shift the other integers down 1 index, ejecting the shortest sequence.
	#If a larger integer ties with a smaller one, keep the smaller one.
	for i in 1:10

		#If a value with the given collatz length is already in the array, break out of the loop
		if(equalFlag == 1)
			break
		end

		#Compare the newly calculated sequence length to the previous 10 longest, and add the new value to the list at the specified index
		#if it has a longer sequence
		if(collatzLength > collatzArr[i, 2])
			#Place the passed in integer and its sequence length into temp variables for swapping
			tempKey1 = key
			tempVal1 = collatzLength
			#Swap values in the array until the shortest sequence length is ejected
			for j in i:10
				tempKey2 = collatzArr[j, 1]
				tempVal2 = collatzArr[j, 2]

				collatzArr[j, 1] = tempKey1
				collatzArr[j, 2] = tempVal1

				tempKey1 = tempKey2
				tempVal1 = tempVal2
			end
			break
		end
	end


end

#Arrays that contain key-value pairs where the key is the integer collatz is preformed on, and the value is the length
#of the sequence. lengthSortArr is used to sort the values by longest length, and collatzArr is sorted by keys (ascending for both).
collatzArr = [0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0]
lengthSortArr = [0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0 ; 0 0]

#User is prompted for an upper bound
print("Please Enter The Upper Bound Of The Range: ")
upperBound = readline()
upperBound = parse(Int64, upperBound)
println()

#Perform collatz on every integer in the range
for i in 1:upperBound

global collatzLength

if(i != 1)
	collatzLength = 0
	collatz(i)
	compare(i)
else
	collatzArr[1, 1] = i
end

end

println("Sorted By Sequence Length:")

#After collatz, collatzArr will be sorted in descending order. This loop reverses the array so that it is in ascending order,
#and prints it to the screen
for i in 1:10

	#Reverse array
	lengthSortArr[i, 1] = collatzArr[11 - i, 1]
	lengthSortArr[i, 2] = collatzArr[11 - i, 2]

	print(lengthSortArr[i, 1])
	print("           ")
	println(lengthSortArr[i, 2])

end

println("")
println("Sorted By Integer Size:")

#Sort the array by key value in ascending order and print it to the screen
for i in 1:10

	global tempKey1
	global tempVal1
	global minIndex

	#Selection sort
	minIndex = i
	for j in i+1:10
		if(collatzArr[j, 1] < collatzArr[minIndex, 1])
			minIndex = j	
		end
	end

	#Swap values after every loop pass
	tempKey1 = collatzArr[minIndex, 1]
        collatzArr[minIndex, 1] = collatzArr[i, 1]
        collatzArr[i, 1] = tempKey1

	tempVal1 = collatzArr[minIndex, 2]
	collatzArr[minIndex, 2] = collatzArr[i, 2]
	collatzArr[i, 2] = tempVal1

	print(tempKey1)
	print("           ")
	println(collatzArr[i, 2])

end

println("")
