unit class Date::Calendar::Persian:ver<0.0.1>;


=begin pod

=head1 NAME

Date::Calendar::Persian - blah blah blah

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
# --> Yek-shanbe 28 Bahman 1399

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

=head1 DESCRIPTION

Date::Calendar::Persian is  a class representing dates  in the Persian
calendar. It  allows you to convert  a Persian date into  Gregorian or
into other implemented  calendars, and it allows you  to convert dates
from Gregorian or from other calendars into Persian.

The Date::Calendar::Persian class gives  the arithmetic version of the
Persian  calendar.  The  astronomic   Persian  calendar  is  partially
implemented in Date::Calendar::Persian::Astronomical, included in this
distribution.


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

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
