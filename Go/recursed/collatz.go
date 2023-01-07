package main

import "fmt"

var upperBound int

//Copies value of passed in argument to preform collatz on
var num int

//Length of each collatz sequence
var collatzLength int

//Arrays that contain key-value pairs where the key is the integer collatz is preformed on, and the value is the length
//of the sequence lengthSortArr is used to sort the values by longest length, and collatzArr is sorted by keys (ascending for both).
var collatzArr [10][2]int
var lengthSortArr [10][2]int

////These temp variables are used for swapping key-value pairs
var tempKey1 int
var tempVal1 int

var tempKey2 int
var tempVal2 int

//Keeps track of index of the minimum integer when sorting by key value
var minIndex int

//Checks if collatz value is equal to any other in the array
var equalFlag int

//Pre-Condition: A positive integer is passed in
//Post-Condition: Collatz sequence is preformed on the passed in integer, adding the integer to a an array
//of the 10 smallest integers with the longest collatz sequences in the specified range if that integer has 
//a longer sequence than one of the 10 integers in the array
func collatz(key int){

	//Set num to the passed in integer
	num = key

	//Recursively preforms calculations on num until it reaches 1, as per the collatz conjecture
	if num != 1{
		//If num is positive, divide it by 2
		if num % 2 == 0{
			num = num/2
			collatzLength = collatzLength + 1
		//Else, multiply it by 3 and add 1, guaranteeing an even number, so then divide by 2
		} else {
			num = (num * 3) + 1
			num = num/2
			collatzLength = collatzLength + 2
		}

		collatz(num)

	}
}

//Pre-Condition: Called immediately after a collatz sequence length is calculated
//Post-Condition: The previously calculated collatz sequence length is compared to an array containing the previous 10
//longest sequences, and is added to the array if it has a longer sequence than one of the values in the array, ejecting the 
//shortest sequence.
func compare(key int){

	equalFlag = 0

	//If the same collatz length can be found in the array, don't duplicate the value
	for l := 0; l < 10; l++{
		if collatzLength == collatzArr[l][1]{
			equalFlag = 1
			break
		}
	}

	//After the sequence length for the passed in integer is calculated, check the 10 values being kept track of
	//to see if the new integer has a longer sequence than one of them. If so, add the new integer to the first index in
	//the array where it has a longer sequence, and shift the other integers down 1 index, ejecting the shortest sequence.
	//If a larger integer ties with a smaller one, keep the smaller one.
	for j := 0; j < 10; j++{
		//If a value with the given collatz length is already in the array, break out of the loop
		if equalFlag == 1{
			break
		}

		//Compare the newly calculated sequence length to the previous 10 longest, and add the new value to the list at the specified index
		//if it has a longer sequence
		if collatzLength > collatzArr[j][1]{
			//Place the passed in integer and its sequence length into temp variables for swapping
			tempKey1 = key
			tempVal1 = collatzLength

			//Swap values in the array until the shortest sequence length is ejected
			for k := j; k < 10; k++{
				tempKey2 = collatzArr[k][0]
				tempVal2 = collatzArr[k][1]
				
				collatzArr[k][0] = tempKey1
				collatzArr[k][1] = tempVal1

				tempKey1 = tempKey2
				tempVal1 = tempVal2

				
			}
			break		
		}
	}



}

func main(){

	//User is prompted for an upper bound
	fmt.Print("Please Enter The Upper Bound Of The Range: ")

	_, err := fmt.Scanf("%d", &upperBound)

	if err != nil{
		fmt.Println(err)
	}

	//Perform collatz on every integer in the range
	for i := 1; i < upperBound + 1;i++{
		if i != 1{
			collatzLength = 0
			collatz(i)
			compare(i)
		} else{
			collatzArr[0][0] = 1
		}
	}

	fmt.Println("Sorted By Sequence Length:")

	//After collatz, collatzArr will be sorted in descending order. This loop reverses the array so that it is in ascending order,
	//and prints it to the screen
	for i := 0; i < 10; i++{
		//Reverse array
		lengthSortArr[i][0] = collatzArr[9 - i][0]
		lengthSortArr[i][1] = collatzArr[9 - i][1]

		fmt.Print(lengthSortArr[i][0])
		fmt.Print("           ")
		fmt.Println(lengthSortArr[i][1])
	}

	fmt.Println("")
	fmt.Println("Sorted By Integer Size:")

	//Sort the array by key value in ascending order and print it to the screen
	for i := 0; i < 10; i++{
		minIndex = i

		//Selection sort
		for j := i + 1; j < 10; j++{
			if collatzArr[j][0] < collatzArr[minIndex][0]{
				minIndex = j
			}
		}

		//Swap values after every loop pass
		tempKey1 = collatzArr[minIndex][0]
		collatzArr[minIndex][0] = collatzArr[i][0]
		collatzArr[i][0] = tempKey1

		tempVal1 = collatzArr[minIndex][1]
		collatzArr[minIndex][1] = collatzArr[i][1]
		collatzArr[i][1] = tempVal1

		fmt.Print(tempKey1)
		fmt.Print("           ")
		fmt.Println(collatzArr[i][1])
		
	}

}
