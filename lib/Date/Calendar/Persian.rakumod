# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Persian::Names;
use Date::Calendar::Persian::Common;

unit class Date::Calendar::Persian:ver<0.1.1>:auth<zef:jforget>:api<1>
      does Date::Calendar::Persian::Common
      does Date::Calendar::Strftime;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Int :$daypart = daylight()) {
  $._chek-build-args($year, $month, $day, &astro-bias);
  $._build-from-args($year, $month, $day, &astro-bias, $daypart);
}

method new-from-daycount(Int $day-count, Int :$daypart = daylight) {
  $.new-from-daycount-and-bias($day-count, &astro-bias, $daypart);
}

method astro-bias {
  astro-bias($.year);
}

our sub astro-bias(Int $yyyy) {
  0;
}

=begin pod

=head1 NAME

Date::Calendar::Persian - Conversions from / to the Persian calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 16th February 2021) into Persian

=begin code :lang<raku>

use Date::Calendar::Persian;
my Date $dt-greg;
my Date::Calendar::Persian $dt-persian;

$dt-greg    .= new(2021, 2, 16);
$dt-persian .= new-from-date($dt-greg);

say $dt-persian;
# --> 1399-11-28
say $dt-persian.strftime("%A %d %B %Y");
# --> Se shanbe 28 Bahman 1399

=end code

Converting a Persian date (e.g. 1 Farvardin 1400) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Persian;
my Date::Calendar::Persian $dt-persian;
my Date $dt-greg;

$dt-persian .= new(year => 1400, month => 1, day => 1);
$dt-greg   = $dt-persian.to-date;

say $dt-greg;
# --> 2021-03-21
=end code

Conversion with a calendar which defines days as sunset to sunset

=begin code :lang<raku>

use Date::Calendar::Strftime;
use Date::Calendar::Hebrew;
use Date::Calendar::Persian;
my  Date::Calendar::Persian $d-pe;
my  Date::Calendar::Hebrew  $d-he;

$d-pe .= new(year => 1403, month => 8, day => 23, daypart => before-sunrise());
$d-he .= new-from-date($d-pe);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Reviʻi 12 Heshvan 5785"

$d-pe .= new(year => 1403, month => 8, day => 23, daypart => daylight());
$d-he .= new-from-date($d-pe);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Reviʻi 12 Heshvan 5785" again

$d-pe .= new(year => 1403, month => 8, day => 23, daypart => after-sunset());
$d-he .= new-from-date($d-pe);
say $d-he.strftime("%A %d %B %Y");
# ---> "Yom Chamishi 13 Heshvan 5785" instead of "Yom Reviʻi 12 Heshvan 5785"

=end code

=head1 DESCRIPTION

Date::Calendar::Persian is  a class representing dates  in the Persian
calendar. It  allows you to convert  a Persian date into  Gregorian or
into other implemented  calendars, and it allows you  to convert dates
from Gregorian or from other calendars into Persian.

The Date::Calendar::Persian class gives  the arithmetic version of the
Persian  calendar.  The  astronomic   Persian  calendar  is  partially
implemented in Date::Calendar::Persian::Astronomical, included in this
distribution.

=head1 METHODS

=head2 Constructors

=head3 new

Create an Persian  date by giving the year, month  and day numbers and
optionally the day part.

=head3 new-from-date

Build an  Persian date by cloning  an object from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx>   class  with   a  C<daycount>   method  and
hopefully a C<daypart> method.

=head3 new-from-daycount

Build an Persian date from the Modified Julian Day number and from the
C<daypart> parameter (optional, defaults do C<daylight>).

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 daypart

A  number indicating  which part  of the  day. This  number should  be
filled   and   compared   with   the   following   subroutines,   with
self-documenting names:

=item before-sunrise()
=item daylight()
=item after-sunset()

=head3 month-name

The month of the date, as a string.

=head3 month-abbr

The month of the  date, as a 3-char string.

=head3 day-name

The name of the day within the week.

=head3 day-abbr

The weekday of the  date, as a 3-char string.

=head3 daycount

The Modified Julian Day Number (a day-only scheme based on 17 November
1858).

=head3 day-of-week

The number of the day within the  week (1 for Saturday / Shanbe, 7 for
Friday / Jumee).

=head3 week-number

The number of the week within the year, 1 to 52 or 1 to 53. Similar to
the "ISO  date" as defined  for Gregorian date.  Week number 1  is the
Sat→Fri span that contains the first  Tuesday / Se shanbe of the year,
week number 2  is the Sat→Fri span that contains  the second Tuesday /
Se shanbe of the year and so on.

=head3 week-year

Mostly similar  to the C<year>  attribute. Yet,  the last days  of the
year  and  the  first  days  of the  following  year  can  be  sort-of
transferred  to the  other year.  The C<week-year>  attribute reflects
this transfer. While the real year  always begins on 1st Farvardin and
ends on  the 29th or  30th Esfand,  the C<week-year> always  begins on
Saturday / Shanbe and it always ends on Friday / Jumee.

=head3 day-of-year

How many  days since  the beginning of  the year. 1  to 365  on normal
years, 1 to 366 on leap years.

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while  converting  "11  Bahman   1440"  to  the  French  Revolutionary
calendar, you can code:

=begin code :lang<raku>

use Date::Calendar::Persian;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Persian             $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 1440
             , month =>   11
             , day   =>   11);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);

=end code

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer. For the Gregorian calendar, instead of the core class C<Date>,
you can use the  child class C<Date::Calendar::Gregorian> which allows
both push and pull styles.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<raku>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long. By  the way, you  can drop the  "at least" mention,  because the
longest month name  is 11-char long, so the padding  will always occur
and will always include at least 14 spaces.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute. Not used with the Persian calendar.

=item A mandatory type code.

The allowed type codes are:

=defn %a

The abbreviated day of week.

=defn %A

The full day of week name.

=defn %b

The abbreviated month name.

=defn %B

The full month name.

=defn %d

The day of the month as a decimal number (range 01 to 31).

=defn %e

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn %f

The month as a decimal number (1  to 12). Unlike C<%m>, a leading zero
is replaced by a space.

=defn %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn %G

The "week year"  as a decimal number. Mostly similar  to C<%Y>, but it
may differ  on the very  first days  of the year  or on the  very last
days. Analogous to the year number  in the so-called "ISO date" format
for Gregorian dates.

=defn %j

The day of the year as a decimal number (range 001 to 366).

=defn %m

The month as a two-digit decimal  number (range 01 to 12), including a
leading zero if necessary.

=defn %n

A newline character.

=defn %Ep

Gives a 1-char string representing the day part:

=item C<☾> or C<U+263E> before sunrise,
=item C<☼> or C<U+263C> during daylight,
=item C<☽> or C<U+263D> after sunset.

Rationale: in  C or in  other programming languages,  when C<strftime>
deals with a date-time object, the day is split into two parts, before
noon and  after noon. The  C<%p> specifier  reflects this by  giving a
C<"AM"> or C<"PM"> string.

The  3-part   splitting  in   the  C<Date::Calendar::>R<xxx>   may  be
considered as  an alternate  splitting of  a day.  To reflect  this in
C<strftime>, we use an alternate version of C<%p>, therefore C<%Ep>.

=defn %t

A tab character.

=defn %u

The day of week as a 1..7 number.

=defn %V

The week  number as defined above,  similar to the week  number in the
so-called "ISO date" format for Gregorian dates.

=defn %Y

The year as a decimal number.

=defn %%

A literal `%' character.

=head1 BUGS AND ISSUES

The astronomical  Persian calendar  is only partially  implemented. It
can represent dates  only in the 1000  to 1800 years (1621  to 2421 in
the Gregorian calendar).

=head2 Security issues

Another  issue,   as  explained  in   the  C<Date::Calendar::Strftime>
documentation. Please ensure that  format-string passed to C<strftime>
comes from a trusted source. Failing that, you could get a format that
includes a outrageous length in a C<strftime> specifier, and you would
drain your PC's RAM very fast.

=head2 Relations with :ver<0.0.x> classes and with core class Date

Version 0.1.0 (and API 1) was  introduced to ease the conversions with
other calendars in  which the day is  defined as sunset-to-sunset.
If all C<Date::Calendar::>R<xxx> classes use  version 0.1.x and API 1,
the conversions will be correct. But if some C<Date::Calendar::>R<xxx>
classes use version 0.0.x and API 0, there might be problems.

A date from a 0.0.x class has no C<daypart> attribute. But when "seen"
from  a  0.1.x class,  the  0.0.x  date  seems  to have  a  C<daypart>
attribute equal to C<daylight>. When converted from a 0.1.x class to a
0.0.x  class,  the  date  may  just  shift  from  C<after-sunset>  (or
C<before-sunrise>) to C<daylight>, or it  may shift to the C<daylight>
part of  the prior (or  next) date. This  means that a  roundtrip with
cascade conversions  may give the  starting date,  or it may  give the
date prior or after the starting date.

If you install C<<Date::Calendar::Persian:ver<0.1.1>>>, why would you
refrain from upgrading other C<Date::Calendar::>R<xxxx> classes? So
actually, this issue applies mainly to the core class C<Date>, because
you may prefer avoiding the installation of
C<Date::Calendar::Gregorian>.

=head2 Time

This module  and the C<Date::Calendar::>R<xxx> associated  modules are
still date  modules, they are not  date-time modules. The user  has to
give  the C<daypart>  attribute  as a  value among  C<before-sunrise>,
C<daylight> or C<after-sunset>. There is no provision to give a HHMMSS
time and convert it to a C<daypart> parameter.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime|https://raku.land/zef:jforget/Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian|https://raku.land/zef:jforget/Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian|https://raku.land/zef:jforget/Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew|https://raku.land/zef:jforget/Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri|https://raku.land/zef:jforget/Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::CopticEthiopic|https://raku.land/zef:jforget/Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Bahai|https://raku.land/zef:jforget/Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<Date::Persian::Simple|https://metacpan.org/pod/Date::Persian::Simple>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-persia.el>  in emacs  or xemacs.

L<https://pypi.org/project/convertdate/>
or L<https://convertdate.readthedocs.io/en/latest/modules/persian.html>

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>

L<https://api.kde.org/frameworks-api/frameworks-apidocs/frameworks/kdelibs4support/html/kcalendarsystemjalali_8cpp_source.html>
Since the KDE version number will change, you should rather use a search engine:
L<https://html.duckduckgo.com/html/?q=calendarsystemjalali%20KDElibs>

=head2 Book

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

=head2 Internet

L<Claus Tøndering's FAQ|https://www.tondering.dk/claus/cal/persian.php>.

L<https://www.funaba.org/cc> (which seems no longer active)

L<https://www.fourmilab.ch/documents/calendar/>
or its French-speaking versions
L<https://www.patricklecoq.fr/convert/cnv_calendar.html>
and L<https://louis-aime.github.io/fourmilab_calendar_upgraded/index-fr.html>

L<https://en.wikipedia.org/wiki/Iranian_calendars>

L<https://www.ephemeride.com/calendrier/autrescalendriers/21/autres-types-de-calendriers.html>
(in French)

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024, 2025 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
