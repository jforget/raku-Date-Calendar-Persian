use v6.c;
unit class Date::Calendar::Persian::Names:ver<0.0.2>:auth<cpan:JFORGET>;

my @month-names = ( "Farvardin"
                  , "Ordibehesht"
                  , "Khordad"
                  , "Tir"
                  , "Mordad"
                  , "Shahrivar"
                  , "Mehr"
                  , "Aban"
                  , "Azar"
                  , "Dei"
                  , "Bahman"
                  , "Esfand"
);

my @month-abbr = < Far Ord Kho Tir Mor Sha
                   Meh Aba Aza Dei Bah Esf >
;

my @day-names = ( "Shanbe"        # S
                , "Yek-shanbe"    # S
                , "Do shanbe"     # M
                , "Se shanbe"     # T
                , "Chahar shanbe" # W
                , "Panj shanbe"   # T
                , "Jumee"         # F
);

my @day-abbr =  ( "Shn" # S
                , "1sh" # S
                , "2sh" # M
                , "3sh" # T
                , "4sh" # W
                , "5sh" # T
                , "Jom" # F
);

our sub month-name(Int:D $month --> Str) {
  return @month-names[$month - 1];
}

our sub month-abbr(Int:D $month --> Str) {
  return @month-abbr[$month - 1];
}

our sub day-name(Int:D $day7 --> Str) {
  return @day-names[$day7];
}

our sub day-abbr(Int:D $day7 --> Str) {
  return @day-abbr[$day7];
}


=begin pod

=head1 NAME

Date::Calendar::Persian::Names - string values for the Persian calendar

=head1 SYNOPSIS

=begin code :lang<perl6>

use Date::Calendar::Persian;

=end code

=head1 DESCRIPTION

Date::Calendar::Persian::Names  is a  utility  module, providing  string
values for the main module Date::Calendar::Persian.

=head1 SOURCES

The names and abbreviations come from
L<https://api.kde.org/frameworks-api/frameworks-apidocs/frameworks/kdelibs4support/html/kcalendarsystemjalali_8cpp_source.html>

Since the KDE version number will change, you should rather use a search engine:
L<https://html.duckduckgo.com/html/?q=calendarsystemjalali%20KDElibs>

=head1 SEE ALSO

=head2 Perl 5 Software

L<Date::Persian::Simple>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-persia.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>

=head2 Books

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

=head2 Internet

L<Claus Tøndering's FAQ|https://www.tondering.dk/claus/cal/persian.php>.

L<https://www.funaba.org/cc>

L<https://en.wikipedia.org/wiki/Iranian_calendars>

=head1 AUTHOR

Jean Forget <JFORGET at cpan dot org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
