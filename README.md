NAME
====

Date::Calendar::Persian - Conversions from / to the Persian calendar

SYNOPSIS
========

Converting a Gregorian date (e.g. 16th February 2021) into Persian

```raku
use Date::Calendar::Persian;
my Date $dt-greg;
my Date::Calendar::Persian $dt-persian;

$dt-greg    .= new(2021, 2, 16);
$dt-persian .= new-from-date($dt-greg);

say $dt-persian;
# --> 1399-11-28
say $dt-persian.strftime("%A %d %B %Y");
# --> Se shanbe 28 Bahman 1399
```

Converting a Persian date (e.g. 1 Farvardin 1400) into Gregorian

```raku
use Date::Calendar::Persian;
my Date::Calendar::Persian $dt-persian;
my Date $dt-greg;

$dt-persian .= new(year => 1400, month => 1, day => 1);
$dt-greg   = $dt-persian.to-date;

say $dt-greg;
# --> 2021-03-21
```

DESCRIPTION
===========

Date::Calendar::Persian is  a class representing dates  in the Persian
calendar. It  allows you to convert  a Persian date into  Gregorian or
into other implemented  calendars, and it allows you  to convert dates
from Gregorian or from other calendars into Persian.

The Date::Calendar::Persian class gives  the arithmetic version of the
Persian  calendar.  The  astronomic   Persian  calendar  is  partially
implemented in Date::Calendar::Persian::Astronomical, included in this
distribution.

INSTALLATION
============

```shell
zef install Date::Calendar::Persian
```

or

```shell
git clone https://github.com/jforget/raku-Date-Calendar-Persian.git
cd raku-Date-Calendar-Persian
zef install .
```

AUTHOR
======

Jean Forget <J2N-FORGET at orange dot fr>

COPYRIGHT AND LICENSE
=====================

Copyright (c) 2021, 2024 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

