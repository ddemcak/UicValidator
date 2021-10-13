# UIC Validator
Tool for UIC wagon number validation.
The simple script is able to validate the 12 digits UIC number or when 11 digits UIC number is provided,
it will calcaulate the 12th self-check digit.

# Parameters
Only one parameter is required with provided UIC number.


## Wiki
https://en.wikipedia.org/wiki/UIC_wagon_numbers

### Description
Calculation of the self-check digit
The digits are multiplied individually from right to left alternately by 2 and 1, and digit summed using the Luhn algorithm. The difference between this sum and the next multiple of ten is the check digit, placed after the eleventh digit, separated by a dash.

