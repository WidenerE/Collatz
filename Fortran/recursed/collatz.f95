module FuncMod
IMPLICIT NONE

!Length of each collatz sequence
integer(kind = 16) :: collatzLength

!Copies value of passed in argument to preform collatz on
integer(kind = 16) :: num

!These temp variables are used for swapping key-value pairs
integer(kind = 16) :: tempKey1
integer(kind = 16) :: tempKey2

integer(kind = 16) :: tempVal1
integer(kind = 16) :: tempVal2

!Keeps track of index of the minimum integer when sorting by key value
integer(kind = 16) :: minIndex

integer(kind = 16) :: upperBound

!Checks if collatz value is equal to any other in the array
integer(kind = 16) :: equalFlag

character(LEN = 1000) :: intConvert
character(LEN = 1000) :: intConvert2

!Arrays that contain key-value pairs where the key is the integer collatz is
!preformed on, and the value is the length
!of the sequence. lengthSortArr is used to sort the values by longest length,
!and collatzArr is sorted by keys (ascending for both).
integer(kind = 16), dimension (10,2) :: collatzArr
integer(kind = 16), dimension (10,2) :: lengthSortArr

!Pre-Condition: A positive integer is passed in
!Post-Condition: Collatz sequence is preformed on the passed in integer, adding
!the integer to a an array
!of the 10 smallest integers with the longest collatz sequences in the specified
!range if that integer has 
!a longer sequence than one of the 10 integers in the array
contains
        RECURSIVE subroutine collatz(key)
        IMPLICIT NONE

        integer(kind = 16), intent (in) :: key
       
        !Set num to the passed in integer 
        num = key

        !Recursively preforms calculations on num until it reaches 1, as per the
        !collatz conjecture
        if(num /= 1) then
                !If num is positive, divide it by 2
                if(mod(num, 2) == 0) then
                        num = num/2
                        collatzLength = collatzLength + 1
                !Else, multiply it by 3 and add 1, guaranteeing an even number,
                !so then divide by 2
                else
                        num = (num * 3) + 1
                        num = num/2
                        collatzLength = collatzLength + 2
                end if
                
        call collatz(num)

        end if
        

        end subroutine collatz

        !Pre-Condition: Called immediately after a collatz sequence length is
        !calculated
        !Post-Condition: The previously calculated collatz sequence length is compared
        !to an array containing the previous 10
        !longest sequences, and is added to the array if it has a longer sequence than
        !one of the values in the array, ejecting the 
        !shortest sequence.
        subroutine compare(key)
        IMPLICIT NONE

        integer(kind = 16), intent (in) :: key
        integer(kind = 16) :: equalFlag

        integer(kind = 16) :: i
        integer(kind = 16) :: j

        equalFlag = 0

        !If the same collatz length can be found in the array, don't duplicate
        !the value
        do i = 1, 10
                if(collatzLength == collatzArr(i, 2)) then
                        equalFlag = 1
                        EXIT
                end if

        end do

        !After the sequence length for the passed in integer is calculated,
        !check the 10 values being kept track of
        !to see if the new integer has a longer sequence than one of them. If
        !so, add the new integer to the first index in
        !the array where it has a longer sequence, and shift the other integers
        !down 1 index, ejecting the shortest sequence.
        !If a larger integer ties with a smaller one, keep the smaller one.
        do i = 1, 10
                !If a value with the given collatz length is already in the
                !array, break out of the loop
                if(equalFlag == 1) then
                        EXIT
                end if

                !Compare the newly calculated sequence length to the previous 10
                !longest, and add the new value to the list at the specified
                !index
                !if it has a longer sequence
                if(collatzLength > collatzArr(i, 2)) then
                        !Place the passed in integer and its sequence length
                        !into temp variables for swapping
                        tempKey1 = key
                        tempVal1 = collatzLength
                        !Swap values in the array until the shortest sequence
                        !length is ejected
                        do j = i, 10
                                tempKey2 = collatzArr(j, 1)
                                tempVal2 = collatzArr(j, 2)

                                collatzArr(j, 1) = tempKey1
                                collatzArr(j, 2) = tempVal1

                                tempKey1 = tempKey2
                                tempVal1 = tempVal2
                        end do 
                        EXIT

                end if
        end do
        

        end subroutine compare

end module FuncMod


program CollatzProg
use FuncMod

IMPLICIT NONE

integer(kind = 16) :: i
integer(kind = 16) :: j

!User is prompted for an upper bound
write(*, "(g0)", advance = 'no') "Please Enter The Upper Bound Of The Range: "
read *, upperBound

!Perform collatz on every integer in the range
do i = 1, upperBound
        if(i /= 1) then
                collatzLength = 0
                call collatz(i)
                call compare(i)
        else
                collatzArr(1, 1) = i
        end if
end do        

print *, "Sorted By Sequence Length:"

!After collatz, collatzArr will be sorted in descending order. This loop
!reverses the array so that it is in ascending order,
!and prints it to the screen
do i = 1, 10
        !Reverse array
        lengthSortArr(i, 1) = collatzArr(11 - i, 1)
        lengthSortArr(i, 2) = collatzArr(11 - i, 2)

        write(intConvert, '(I0)') lengthSortArr(i, 1)
        write(intConvert2, '(I0)') lengthSortArr(i, 2)
        write(*, "(g0)", advance = 'no') TRIM(intConvert) // "           " // TRIM(intConvert2)
        print *, ""
end do

print *, ""
print *, "Sorted By Integer Size:"

!Sort the array by key value in ascending order and print it to the screen
do i = 1, 10

        !Selection sort
        minIndex = i
        do j = i + 1, 10
                if(collatzArr(j, 1) < collatzArr(minIndex, 1)) then
                        minIndex = j
                end if
        end do

        !Swap values after every loop pass
        tempKey1 = collatzArr(minIndex, 1)
        collatzArr(minIndex, 1) = collatzArr(i, 1)
        collatzArr(i, 1) = tempKey1

        tempVal1 = collatzArr(minIndex, 2)
        collatzArr(minIndex, 2) = collatzArr(i, 2)
        collatzArr(i, 2) = tempVal1

        write(intConvert, '(I0)') tempKey1
        write(intConvert2, '(I0)') collatzArr(i, 2)
        write(*, "(g0)", advance = 'no') TRIM(intConvert) // "           " //  TRIM(intConvert2)
        print *, ""
end do

print *, ""

end program CollatzProg
