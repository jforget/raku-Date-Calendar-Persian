# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Persian::Names;
use Date::Calendar::Strftime;

unit role Date::Calendar::Persian::Common:ver<0.0.1>:auth<cpan:JFORGET>;

has Int $.year;
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 31 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
}

method _chek-build-args(Int $year, Int $month, Int $day) {
  unless 1 ≤ $month ≤ 12 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..12>).throw;
  }
  my $limit =  month-days($year, $month);
  unless 1 ≤ $day ≤ $limit {
    X::OutOfRange.new(:what<Day>, :got($day), :range("1..$limit for this month and this year")).throw;
  }
}


method _build-from-args(Int $year, Int $month, Int $day) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;

  # computing derived attributes TODO
  my Int $daycount   = 1;
  my Int $dow        = 2;
  my Int $doy        = 3;

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes
  my Int $doy-se-shanbe = $doy - $dow + 4; # day-of-year value for the nearest Se shanbe / Tuesday
  my Int $week-year     = $year;
  if $doy-se-shanbe ≤ 0 {
    -- $week-year;
    $doy          += year-days($week-year);
    $doy-se-shanbe = $doy - $dow + 4;
  }
  else {
    my $year-length = year-days($week-year);
    if $doy-se-shanbe > $year-length {
      $doy          -= $year-length;
      $doy-se-shanbe = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-se-shanbe / 7).ceiling;

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}

sub month-days(Int $year, Int $month --> Int) {
 return 31 if $month ≤ 6;
 return 29 if $month == 12 && ! is-leap($year);
 return 30;
}

sub year-days(Int $year --> Int) {
 return 366 if is-leap($year);
 return 365;
}

sub is-leap(Int $year --> Any) {
  # TODO
  return False;
}

=begin pod

=head1 NAME

Date::Calendar::Persian::Common - Behind-the-scene role for Date::Calendar::Persian and Date::Calendar::Persian::Astronomical

=head1 DESCRIPTION

This role  is not meant  to be used directly  by user programs.  It is
meant   to    be   used   by   the    C<Date::Calendar::Persian>   and
C<Date::Calendar::Persian::Astronomical>  classes.   Please  refer  to
theses classes' documentation.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
