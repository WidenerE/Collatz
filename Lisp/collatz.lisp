#!/usr/bin/sbcl --script

(defvar upperBound)

;Copies value of passed in argument to preform collatz on
(defvar num)

;Length of each collatz sequence
(defvar collatzLength)

;Arrays that contain key-value pairs where the key is the integer collatz is preformed on, and the value is the length
;of the sequence. lengthSortArr is used to sort the values by longest length, and collatzArr is sorted by keys (ascending for both).
(defvar collatzArr)
(defvar lengthSortArr)

;These temp variables are used for swapping key-value pairs
(defvar tempKey1)
(defvar tempVal1)

(defvar tempKey2)
(defvar tempVal2)

;Keeps track of index of the minimum integer when sorting by key value
(defvar minIndex)

;Checks if collatz value is equal to any other in the array
(defvar equalFlag)

;Pre-Condition: A positive integer is passed in
;Post-Condition: Collatz sequence is preformed on the passed in integer, adding the integer to a an array
;of the 10 smallest integers with the longest collatz sequences in the specified range if that integer has 
;a longer sequence than one of the 10 integers in the array
(defun collatz (key)

	;Set num to the passed in integer
	(setf num key)
	;Reset the sequence length counter
	(setf collatzLength 0)

	(cond((/= key 1)
		;This loop preforms calculations on num until it reaches 1, as per the collatz conjecture
		(loop while (/= num 1)
			;If num is positive, divide it by 2
			do(cond((=(mod num 2) 0)
				(setf num (/ num 2))
				(setf collatzLength (+ collatzLength 1))
			)
			;Else, multiply it by 3 and add 1, guaranteeing an even number, so then divide by 2
			(t	(setf num (* num 3))
				(setf num (+ num 1))
				(setf num (/ num 2))

				(setf collatzLength (+ collatzLength 2))
			))
		
		)
	

	;Reset equal flag
	(setf equalFlag 0)
	
	;If the same collatz length can be found in the array, don't duplicate the value
	(loop for l from 0 to 9
		do(cond((= collatzLength (aref collatzArr l 1))
		        (setf equalFlag 1)
	                (loop-finish)
	        ))
	)
		

	;After the sequence length for the passed in integer is calculated, check the 10 values being kept track of
	;to see if the new integer has a longer sequence than one of them. If so, add the new integer to the first index in
	;the array where it has a longer sequence, and shift the other integers down 1 index, ejecting the shortest sequence.
	;If a larger integer ties with a smaller one, keep the smaller one.
	(loop for j from 0 to 9
	

		;If a value with the given collatz length is already in the array, break out of the loop
		do(cond((= equalFlag 1)
			(loop-finish)
		))

		;Compare the newly calculated sequence length to the previous 10 longest, and add the new value to the list at the specified index
		;if it has a longer sequence
		(cond((> collatzLength (aref collatzArr j 1))

			;Place the passed in integer and its sequence length into temp variables for swapping
			(setf tempKey1 key)
			(setf tempVal1 collatzLength)
			;Swap values in the array until the shortest sequence length is ejected
			(loop for k from j to 9
				do(setf tempKey2  (aref collatzArr k 0))
                                (setf tempVal2  (aref collatzArr k 1))

                                (setf (aref collatzArr k 0) tempKey1)
                                (setf (aref collatzArr k 1) tempVal1)

				(setf tempKey1  tempKey2)
                                (setf tempVal1  tempVal2)
                        )
			;Break out of the loop
			(loop-finish)
		))
	
	)
)
(t	(setf (aref collatzArr 0 0) key)
))

)

;;;Driver Program

;initilize each array to store 10 key-value pairs where the key is the integer and the value its sequence length
(setf collatzArr (make-array '(10 2):initial-element 0))
(setf lengthSortArr (make-array '(10 2):initial-element 0))

;User is prompted for an upper bound
(princ "Please Enter The Upper Bound Of The Range: ")

(finish-output)

;Reads in keyboard input
(setq upperBound (read))

;Perform collatz on every integer in the range
(loop for i from 1 to upperBound

	do(collatz i)

)

(princ "Sorted By Sequence Length:")
(terpri)

;After collatz, collatzArr will be sorted in descending order. This loop reverses the array so that it is in ascending order,
;and prints it to the screen
(loop for i from 0 to 9

	;Reverse array
	do(setf (aref lengthSortArr i 0) (aref collatzArr (- 9 i) 0))
	(setf (aref lengthSortArr i 1) (aref collatzArr (- 9 i) 1))

	;Print to screen
	(princ (aref lengthSortArr i 0))
	(princ "           ")
	(princ (aref lengthSortArr i 1))
	(terpri)

)

(princ "")
(terpri)
(princ "Sorted By Integer Size:")
(terpri)

;Sort the array by key value in ascending order and print it to the screen
(loop for i from 0 to 9

	;Selection sort
	do(setf minIndex i)
	(loop for j from (+ i 1) to 9
		do(cond((< (aref collatzArr j 0) (aref collatzArr minIndex 0))
			(setf minIndex j)))
		

	)

	;Swap values after every loop pass
	(setf tempKey1 (aref collatzArr minIndex 0))
	(setf (aref collatzArr minIndex 0) (aref collatzArr i 0))
	(setf (aref collatzArr i 0) tempKey1)

	(setf tempVal1 (aref collatzArr minIndex 1))
	(setf (aref collatzArr minIndex 1) (aref collatzArr i 1))
	(setf (aref collatzArr i 1) tempVal1)

	;Print to screen
	(princ tempKey1)
	(princ "           ")
	(princ (aref collatzArr i 1))
	(terpri)

)
(terpri)

