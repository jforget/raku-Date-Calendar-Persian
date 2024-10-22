# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Persian::Names;
use Date::Calendar::Strftime;

unit role Date::Calendar::Persian::Common:ver<0.0.2>:auth<zef:jforget>:api<0>;

has Int $.year;
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 31 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method _chek-build-args(Int $year, Int $month, Int $day, &bias) {
  if $year ≤ 0 {
    X::OutOfRange.new(:what<Year>, :got($year), :range<1..inf>).throw;
  }
  unless 1 ≤ $month ≤ 12 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..12>).throw;
  }
  my Int $limit =  month-days($year, $month, &bias);
  unless 1 ≤ $day ≤ $limit {
    X::OutOfRange.new(:what<Day>, :got($day), :range("1..$limit for this month and this year")).throw;
  }
}


method _build-from-args(Int $year, Int $month, Int $day, &bias) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;

  # computing derived attributes TODO
  my Int $daycount   = persian-daycount($year, $month, $day, &bias);
  my Int $dow        = ($daycount + 4) % 7 + 1;
  my Int $doy        = $daycount - persian-daycount($year, 1, 0, &bias);

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes
  my Int $doy-se-shanbe = $doy - $dow + 4; # day-of-year value for the nearest Se shanbe / Tuesday
  my Int $week-year     = $year;
  if $doy-se-shanbe ≤ 0 {
    -- $week-year;
    $doy          += year-days($week-year, &bias);
    $doy-se-shanbe = $doy - $dow + 4;
  }
  else {
    my Int $year-length = year-days($week-year, &bias);
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

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method month-name {
  Date::Calendar::Persian::Names::month-name($.month);
}

method month-abbr {
  Date::Calendar::Persian::Names::month-abbr($.month);
}

method day-name {
  Date::Calendar::Persian::Names::day-name($.day-of-week - 1);
}

method day-abbr {
  Date::Calendar::Persian::Names::day-abbr($.day-of-week - 1);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount);
}

# Epoch for the Persian calendar: 0622-03-19 in the Julian calendar,
#                                 0622-03-22 in the proleptic Gregorian calendar
my Date $persian-epoch .= new(622, 3, 22);

method new-from-daycount-and-bias(Int $day-count, $bias-fct) {
  my Int $pers-day-count = $day-count - $persian-epoch.daycount + 1;
  my Int $yyyy = ($pers-day-count / 365).ceiling;
  while persian-daycount($yyyy, 1, 1, $bias-fct) > $day-count {
    -- $yyyy;
  }
  my Int $day-of-year = 1 + $day-count - persian-daycount($yyyy, 1, 1, $bias-fct);
  my Int $mm;
  my Int $dd;
  if $day-of-year ≤ 186 {
    $mm =  ($day-of-year / 31).ceiling;
    $dd = $day-of-year - ($mm - 1) × 31;
  }
  else {
    $mm = 6 + (($day-of-year - 186) / 30).ceiling;
    $dd = $day-of-year - 186 - ($mm - 7) × 30;
  }
  $.new(year => $yyyy, month => $mm, day => $dd);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount);
  return $d;
}

sub persian-daycount(Int $yyyy, Int $mm, Int $dd, $bias) {
  my Int $ep-base = $yyyy - 474;
  my Int $ep-year = 474  + $ep-base % 2820;
  my Int $nbdays = $persian-epoch.daycount    # Persian epoch's MJD
                 + 1029983 × ($ep-base / 2820).floor
                 + 365 × ($ep-year - 1)
                 + ((682 × $ep-year - 110) / 2816).floor
                 + $bias($yyyy)
                 + 31 × (6 min ($mm - 1))   # 31-day months before current month
                 + 30 × (0 max ($mm - 7))   # 30-day months before current month
                 + $dd - 1;
}

sub month-days(Int $year, Int $month, &bias --> Int) {
 return 31 if $month ≤ 6;
 return 29 if $month == 12 && ! is-leap($year, &bias);
 return 30;
}

sub year-days(Int $year, &bias --> Int) {
 return persian-daycount($year + 1, 1, 0, &bias)
      - persian-daycount($year    , 1, 0, &bias);
}

sub is-leap(Int $year, &bias --> Any) {
  return 366 == year-days($year, &bias);
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

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021, 2024 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
