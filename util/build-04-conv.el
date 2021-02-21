#!/usr/bin/emacs --script
;; -*- encoding: utf-8; indent-tabs-mode: nil -*-
;;
;;     Emacs-Lisp script to build test data for Raku's Date::Calendar::Persian
;;     Copyright (C) 2021 Jean Forget
;;
;;     This program is distributed under the GNU Public License version 1 or later
;;
;;     You can find the text of the license in the F<LICENSE> file or at
;;     L<http://www.gnu.org/licenses/gpl-1.0.html>.
;;
;;     Here is the summary of GPL:
;;
;;     This program is free software; you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation; either version 1, or (at your option)
;;     any later version.
;;
;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.
;;
;;     You should have received a copy of the GNU General Public License
;;     along with this program; if not, write to the Free Software Foundation,
;;     Inc., L<http://www.fsf.org/>.
;;

(load "/usr/share/emacs/25.1/lisp/calendar/calendar.el")
(load "/usr/share/emacs/25.1/lisp/calendar/cal-persia.el")

(defun compar (absol)
  (let ((pers (calendar-persian-from-absolute   absol))
        (greg (calendar-gregorian-from-absolute absol)))
    (princ (format "       , < %4d %2d %2d      %4d %2d %2d >\n" 
                               (nth 2 pers) (nth 0 pers) (nth 1 pers)
                               (nth 2 greg) (nth 0 greg) (nth 1 greg)
    ))
  )
)


(let ((year        2)
      (year-max 2000))
  (while (<= year year-max)
    (let ((absol (calendar-persian-to-absolute (list 1 1 year))))
      (compar (- absol 1))
      (compar    absol   )
    )
    (setq year (1+ year))
  )
)

(let ((year     1400)
      (month       2)
      (month-max  11))
  (while (<= month month-max)
    (let ((absol (calendar-persian-to-absolute (list month 1 year))))
      (compar (- absol 1))
      (compar    absol   )
    )
    (setq month (1+ month))
  )
)
