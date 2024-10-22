This sub-directory  contains utility progams used  for developping the
`Date::Calendar::Persian` module, especially its test files.

build-04-conv.el
================

This script builds test data to include in `t/04-conversion.rakutest`.
These test data are generated from Emacs' `calendar/cal-persia.el`.

How to use
----------

First,   ensure   the   path  to   `calendar/cal-persia.el`   and   to
`calendar/calendar.el` is correct. Your Emacs version may be a version
other than 25.1.

Second, run the script from the  command line, redirecting stdout to a
temporary file. Do  not bother with stderr.  This generates conversion
data for each New Year's day for Persian years 2 to 2000, for each New
Year's eve for  Persian years 1 to  1999 and for each  month begin and
end in Persian year 1400.

Third, choose a  significant sample of test dates.  Checking more than
4000 dates is overkill, so delete some  of them to have a much smaller
sample, still checking enough special cases such as leap years.

You may wish to move the  year 1400 dates to their chronological place
instead of leaving them  at the end of the test data.  But this is not
required.

Insert the test data in  `t/04-conversion.rakutest` and add manually a
line  for the  Persian  epoch, 1  Farvardin  1 (22  March  622 in  the
proleptic  Gregorian  calendar,  that  is   19  March  in  the  Julian
calendar).

build-08-week.raku
==================

This script helps  building data to check  the week-related attributes
in   Persian  dates   objects.   It  uses   a  partially   implemented
`Date::Calendar::Persian` module.

First Step
----------

Comment out  then `list(...  True)` line  and uncomment  the `list(...
False)` line.

Run the script.

Check that  the displayed days  of week  correspond to the  real days:
either check  with what  `build-04-conv.el` has  generated or  use the
calendar functions in Emacs.

* Shanbe → Saturday

* Yek shanbe → Sunday

* Do shanbe → Monday

* Se shanbe → Tuesday

* Chahar shanbe → Wednesday

* Panj shanbe → Thursday

* Jumee → Friday

Find an interval of years with  a significant sample of years changes.
It should  contain at  least the  three cases  where the  week-year is
53-week long:

* Normal year beginning on Se shanbe (e.g. year 1447),

* Leap year beginning on Do shanbe (e.g. year 1441),

* Leap year beginning on Se shanbe (e.g. year 1453).

Please note that you have to  read two successive lines, the first one
for  the beginning  of the  year, the  second one  for the  year type:
normal / leap.

Second Step
-----------

Comment out  the `list(...  False)` line  and uncomment  the `list(...
True)` line.  Update the  span of  years in this  line to  include the
sample chosen in the first step.

Run the script, redirecting stdout to a text file.

Edit  this file.  On each  line, update  the `nnnn-Wnn-n`  value. From
right to left:

* Check that the day-of-week is the proper one.

* Change the  week number from "00"  to the proper value,  "01", "02",
  "51, "52" or even "53".

* Change the week-year value by adding or subtracting 1 to the current
value (which has been initialised with the normal year value).

For  number  litterals (month  numbers,  day  numbers and  day-of-year
numbers),  remove  the leading  zeros,  e.g.  replacing "001"  by  "1"
preceded  by two  spaces and  replacing "02"  by "2"  preceded by  one
space.

Insert the resulting text into `t/08-week.rakutest`.
