#!/usr/bin/env raku -I../lib
# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Persian;

#list(1400, 1500, False);
list(1440, 1454, True);

sub list(Int $yr1, Int $yr2, Bool $detail) {
  for $yr1 .. $yr2 -> $year {
    my Date::Calendar::Persian $first .= new(year => $year + 1, month =>  1, day =>  1);
    my Date::Calendar::Persian $last  .= new-from-daycount($first.daycount - 1);
    my Int $nb = $last.daycount;
    my Str $type = 'normal';
    if $last.day == 30 {
      $type = 'leap';
    }
    say "              # {$year + 1} begins on {$first.day-name} and $year is $type";
    if $detail {
      for 25 .. $last.day -> $day {
        aff($year, 12, $day);
      }
      for 1 .. 6 -> $day {
        aff($year + 1, 1, $day);
      }
    }
  }
}

sub aff(Int $year, Int $mois, Int $day) {
  my Date::Calendar::Persian $date .= new(year => $year, month => $mois, day => $day);
  my Str $tag = '   ';
  my Int $dow = 1 + ($date.daycount + 4) % 7;
  if $dow == 1 {
    # beginning of week
    $tag = 'vvv';
  }
  if $dow == 4 {
    # middle of week
    $tag = '...';
  }
  if $dow == 7 {
    # end of week
    $tag = '^^^';
  }
  say $date.strftime("            , (%04Y, %2m, %2d, %3j, '%04Y-W00-$dow') # $tag %A %d %B %Y");
}
