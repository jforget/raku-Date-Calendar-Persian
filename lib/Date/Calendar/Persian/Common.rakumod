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

=begin pod

=head1 NAME

Date::Calendar::Julian::Common - Behind-the-scene role for Date::Calendar::Julian and Date::Calendar::Julian::AUC

=head1 DESCRIPTION

This role  is not meant  to be used directly  by user programs.  It is
meant   to    be   used    by   the    C<Date::Calendar::Julian>   and
C<Date::Calendar::Julian::AUC>   classes.  Please   refer  to   theses
classes' documentation.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020, 2021 Jean Forget

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
