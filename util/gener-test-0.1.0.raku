#!/usr/bin/env raku
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Générer les données de test pour 09-conv-old.rakutest et 10-conv-new.rakutest
# Generate test data for 09-conv-old.rakutest and 10-conv-new.rakutest
#

use v6.d;
use Date::Calendar::Strftime:ver<0.1.0>;
use Date::Calendar::Aztec;
use Date::Calendar::Aztec::Cortes;
use Date::Calendar::Bahai;
use Date::Calendar::Bahai::Astronomical;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;
use Date::Calendar::Hebrew;
use Date::Calendar::Hijri;
use Date::Calendar::Gregorian;
use Date::Calendar::FrenchRevolutionary;
use Date::Calendar::FrenchRevolutionary::Arithmetic;
use Date::Calendar::FrenchRevolutionary::Astronomical;
use Date::Calendar::Julian;
use Date::Calendar::Julian::AUC;
use Date::Calendar::Maya;
use Date::Calendar::Maya::Astronomical;
use Date::Calendar::Maya::Spinden;
use Date::Calendar::Persian;
use Date::Calendar::Persian::Astronomical;

my %class =   a0 => 'Date::Calendar::Aztec'
            , a1 => 'Date::Calendar::Aztec::Cortes'
            , ba => 'Date::Calendar::Bahai'
            , be => 'Date::Calendar::Bahai::Astronomical'
            , gr => 'Date::Calendar::Gregorian'
            , co => 'Date::Calendar::Coptic'
            , et => 'Date::Calendar::Ethiopic'
            , fr => 'Date::Calendar::FrenchRevolutionary'
            , fa => 'Date::Calendar::FrenchRevolutionary::Arithmetic'
            , fe => 'Date::Calendar::FrenchRevolutionary::Astronomical'
            , he => 'Date::Calendar::Hebrew'
            , hi => 'Date::Calendar::Hijri'
            , jl => 'Date::Calendar::Julian'
            , jc => 'Date::Calendar::Julian::AUC'
            , m0 => 'Date::Calendar::Maya'
            , m1 => 'Date::Calendar::Maya::Astronomical'
            , m2 => 'Date::Calendar::Maya::Spinden'
            , pe => 'Date::Calendar::Persian'
            , pa => 'Date::Calendar::Persian::Astronomical'
            ;

my %midnight = ba => False
             , be => False
             , co => False
             , et => False
             , fr => True
             , fa => True
             , fe => True
             , gr => True
             , he => False
             , hi => False
             , jl => True
             , jc => True
             , pe => True
             , pa => True
             ;

my @new-maya;
my @new-others;

say '09-conv-old.rakutest variables @data and then @data-greg';
gener-others('ba', 1400,  7,  4);
gener-others('be', 1403, 10, 16);
gener-others('co', 1402,  2, 27);
gener-others('et', 1401,  4,  6);
gener-others('fr', 1403,  9, 12);
gener-others('fa', 1401,  8, 10);
gener-others('fe', 1402,  6, 21);
gener-others('gr', 1400, 12,  5);
gener-others('he', 1402, 11,  6);
gener-others('hi', 1400,  3, 15);
gener-others('jl', 1403,  9, 29);
gener-others('jc', 1403,  8,  2);
gener-others('pe', 1401, 11, 27);
gener-others('pa', 1400, 10,  2);
say '-' x 50;
say '09-conv-old.rakutest variable @data-maya';
gener-maya('m0', 1403,  7, 11);
gener-maya('m1', 1401,  9,  7);
gener-maya('m2', 1403,  1, 20);
gener-maya('a0', 1403, 10,  1);
gener-maya('a1', 1402,  6, 10);
say '-' x 50;
say '10-conv-new.rakutest variables @data-to-do and @data';
say @new-others.join("");
say '-' x 50;
say '10-conv-new.rakutest variable @data-maya';
say @new-maya.join("");

sub gener-others($key, $year, $month, $day) {
  my Date::Calendar::Persian $dp1 .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Persian $dp2 .= new-from-daycount($dp1.daycount + 1);
  my     $d1  = $dp1.to-date(%class{$key});
  my     $d2  = $dp2.to-date(%class{$key});
  my Str $s1  = $d1 .strftime('"%A %d %b %Y"');
  my Str $sp1 = $dp1.strftime('"%a %d %b %Y ☼"');
  my Str $gr1 = $dp1.to-date.gist;
  my Str $s2;
  my Str $sp2;
  my Int $lg-s1 = 26;
  my Int $lg-sp = 19;
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sp1.chars < $lg-sp { $sp1 ~= ' ' x ($lg-sp - $sp1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sp1, "$gr1 shift to daylight")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sp1, "$gr1 no problem")
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s1, $sp1, "$gr1 shift to daylight")
  EOF

  $s1  = $d1 .strftime("%A %d %b %Y");
  $s2  = $d2 .strftime("%A %d %b %Y");
  $sp1 = $dp1.strftime("%a %d %b %Y");
  $sp2 = $dp2.strftime("%a %d %b %Y");
  my Int $lg = 24;
  my Str $w1 = ''; if $s1.chars < $lg { $w1 = ' ' x ($lg - $s1.chars); }
  my Str $w2 = ''; if $s1.chars < $lg { $w2 = ' ' x ($lg - $s2.chars); }
  if %midnight{$key} {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sp1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sp1 ☼", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s1 ☽"$w1, "$sp1 ☽", "Gregorian: $gr1")
    EOF
  }
  else {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sp1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sp1 ☼", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s2 ☽"$w2, "$sp1 ☽", "Gregorian: $gr1")
    EOF
  }
}

sub gener-maya($key, $year, $month, $day) {
  my Date::Calendar::Persian $dp1 .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Persian $dp0 .= new-from-daycount($dp1.daycount - 1);
  my Date::Calendar::Persian $dp2 .= new-from-daycount($dp1.daycount + 1);
  my Str $sp0;
  my Str $sp1 = $dp1.strftime('"%a %d %b %Y ☼"');
  my Str $sp2;
  my     $d0  = $dp0.to-date(%class{$key});
  my     $d1  = $dp1.to-date(%class{$key});
  my     $d2  = $dp2.to-date(%class{$key});
  my Str $s0;
  my Str $s1  = $d1 .strftime('"%e %B %V %A"');
  my Str $s2;
  my Str $l0  = $d0 .strftime( '%e %B ') ~ $d1.strftime( '%V %A');
  my Str $l2  = $d1 .strftime( '%e %B ') ~ $d2.strftime( '%V %A');
  my Str $gr1 = $dp1.to-date.gist;
  my Int $lg-s1 = 24;
  my Int $lg-sp = 19;
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sp1.chars < $lg-sp { $sp1 ~= ' ' x ($lg-sp - $sp1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sp1, "$gr1 wrong intermediate date, should be $l0")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sp1, "$gr1 no problem")
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s1, $sp1, "$gr1 wrong intermediate date, should be $l2")
  EOF

  $sp0 = $dp1.strftime('"%a %d %b %Y ☾"');
  $sp1 = $dp1.strftime('"%a %d %b %Y ☼"');
  $sp2 = $dp1.strftime('"%a %d %b %Y ☽"');
  $s1  = $d1 .strftime('"%e %B %V %A"');
  $s0  = $d0 .strftime('"%e %B ') ~ $d1.strftime('%V %A"');
  $s2  = $d1 .strftime('"%e %B ') ~ $d2.strftime('%V %A"');
  $lg-s1 = 29;
  $lg-sp = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $s2 .chars < $lg-s1 { $s2  ~= ' ' x ($lg-s1 - $s2 .chars); }
  if $sp0.chars < $lg-sp { $sp0 ~= ' ' x ($lg-sp - $sp0.chars); }
  if $sp1.chars < $lg-sp { $sp1 ~= ' ' x ($lg-sp - $sp1.chars); }
  if $sp2.chars < $lg-sp { $sp2 ~= ' ' x ($lg-sp - $sp2.chars); }
  push @new-maya, qq:to<EOF>;
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s0, $sp0, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sp1, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s2, $sp2, "Gregorian: $gr1")
  EOF
}

=begin pod

=head1 NAME

gener-test-0.1.0.raku -- Generation of test data

=head1 SYNOPSIS

  raku gener-test-0.1.0.raku > /tmp/test-data

copy-paste from /tmp/test-data to the tests scripts.

=head1 DESCRIPTION

This  program  uses  the  various  C<Date::Calendar::>R<xxx>  classes,
version 0.0.x and  API 0, to generate test data  for version 0.1.0 and
API 1.  After the  test data  are generated,  check them  with another
source (the calendar  functions in Emacs, some  websites, some Android
apps). Please remember that the other sources do not care about sunset
(and sunrise for the civil Maya and Aztec calendars) and that you will
have to mentally shift the results before the comparison.

And after  the data are  checked, copy-paste  the lines into  the test
scripts C<xt/09-conv-old.rakutest> and C<xt/10-conv-new.rakutest>.

In C<xt/09-conv-old.rakutest>,  fill the C<@data-maya> array  with the
lines listing Maya and Aztec  dates and fill the C<@data-others> array
with the lines listing other dates. Then cut the lines listing C<'gr'>
dates  and  paste  them  into  the C<@data-greg>  array  and  add  the
Gregorian date with  the 'YYYY-MM-AA' format at the end  of each array
line.

In C<xt/10-conv-new.rakutest>,  fill the C<@data-maya> array  with the
lines listing  Maya and Aztec dates  and fill the C<@data>  array with
the lines listing other dates. Then cut the lines listing the calendar
not yet converted  to version 0.1.0 or  API 1 and paste  them into the
C<@data-to-do>  array.  Then,  as  the other  modules  are  converted,
cut-and-paste  the   corresponding  lines  from   C<@data-to-do>  into
C<@data>.

Remember  that you  need to  erase the  first comma  in each  chunk of
copied-pasted code.

Test data  are generated only for  C<Date::Calendar::Persian>, not for
the astronomical variant.

All computed  dates are daylight  dates. So  it does not  matter which
version  and API  are  such  and such  classes.  Daylight dates  gives
exactly the  same results with version  0.1.0 / API 1  as with version
0.0.x / API 0.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2024 Jean Forget, all rights reserved

This program is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
