# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Persian::Names;
use Date::Calendar::Persian::Common;

unit class Date::Calendar::Persian::Astronomical:ver<0.0.2>:auth<zef:jforget>:api<0>
      does Date::Calendar::Persian::Common
      does Date::Calendar::Strftime;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  unless 1000 ≤ $year ≤ 1800 {
    X::OutOfRange.new(:what<Year>, :got($year), :range<1000..1800>).throw;
  }
  $._chek-build-args($year, $month, $day, &astro-bias);
  $._build-from-args($year, $month, $day, &astro-bias);
}

method new-from-daycount(Int $day-count) {
  $.new-from-daycount-and-bias($day-count, &astro-bias);
}

method astro-bias {
  astro-bias($.year);
}

sub astro-bias(Int $yyyy) {
  if $yyyy == 1016 | 1049 | 1078 | 1082 | 1111 | 1115 | 1144 | 1177 | 1210 | 1243 {
    return -1;
  }
  if $yyyy == 1404 | 1437 | 1532 | 1565 | 1569 | 1598
            | 1631 | 1660 | 1664 | 1693 | 1697
            | 1726 | 1730 | 1759 | 1763 | 1788 | 1792 | 1796 {
    return +1;
  }
  return 0;
};

=begin pod

=head1 NAME

Date::Calendar::Persian::Astronomical - Conversions from / to the astronomical Persian calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 16th February 2021) into Persian

=begin code :lang<raku>

use Date::Calendar::Persian::Astronomical;
my Date $dt-greg;
my Date::Calendar::Persian::Astronomical $dt-persian;

$dt-greg    .= new(2021, 2, 16);
$dt-persian .= new-from-date($dt-greg);

say $dt-persian;
# --> 1399-11-28
say $dt-persian.strftime("%A %d %B %Y");
# --> Yek-shanbe 28 Bahman 1399

=end code

Converting a Persian date (e.g. 1 Farvardin 1400) into Gregorian

=begin code :lang<raku>
use Date::Calendar::Persian::Astronomical;
my  Date::Calendar::Persian::Astronomical $dt-persian;
my  Date $dt-greg;

$dt-persian .= new(year => 1400, month => 1, day => 1);
$dt-greg   = $dt-persian.to-date;

say $dt-greg;
# --> 2021-03-21
=end code

=head1 DESCRIPTION

Date::Calendar::Persian::Astronomical is a class representing dates in
the astronomical Persian calendar. It  allows you to convert a Persian
date into Gregorian or into other implemented calendars, and it allows
you  to convert  dates from  Gregorian  or from  other calendars  into
Persian.

The distribution provides also the Date::Calendar::Persian class which
gives the arithmetic version of the Persian calendar.

The astronomical  Persian calendar  is only partially  implemented. It
can represent dates  only in the 1000  to 1800 years (1621  to 2421 in
the Gregorian calendar).


=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<Date::Persian::Simple>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-persia.el>  in emacs  or xemacs.

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

L<https://www.funaba.org/cc>

L<https://en.wikipedia.org/wiki/Iranian_calendars>

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
