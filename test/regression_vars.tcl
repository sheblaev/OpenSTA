# Parallax Static Timing Analyzer
# Copyright (c) 2019, Parallax Software, Inc.
# All rights reserved.
# 
# No part of this document may be copied, transmitted or
# disclosed in any form or fashion without the express
# written consent of Parallax Software, Inc.

# Regression variables.

# Application program to run tests on.
if { [regexp "CYGWIN" [exec uname -a]] } {
  set app "sta.exe"
} else {
  set app "sta"
}
set sta_dir [find_parent_dir $test_dir]
set app_path [file join $sta_dir "app" $app]
# Application options.
set app_options "-no_init -no_splash -exit"
# Log files for each test are placed in result_dir.
set result_dir [file join $test_dir "results"]
# Collective diffs.
set diff_file [file join $result_dir "diffs"]
# File containing list of failed tests.
set failure_file [file join $result_dir "failures"]
# Use the DIFF_OPTIONS envar to change the diff options
# (Solaris diff doesn't support this envar)
set diff_options "-c"
if [info exists env(DIFF_OPTIONS)] {
  set diff_options $env(DIFF_OPTIONS)
}

set valgrind_suppress [file join $test_dir valgrind.suppress]
set valgrind_options "--num-callers=20 --leak-check=full --freelist-vol=100000000 --leak-resolution=high --suppressions=$valgrind_suppress"
if { [exec "uname"] == "Darwin" } {
  append valgrind_options " --dsymutil=yes"
}

proc cleanse_logfile { test log_file } {
  # Nothing to be done here.
}

################################################################

# Record a test in the regression suite.
proc record_test { test cmd_dir } {
  global cmd_dirs test_groups
  set cmd_dirs($test) $cmd_dir
  lappend test_groups(all) $test
  return $test
}

# Record a test in the $STA/examples directory.
proc record_example_tests { tests } {
  global test_dir test_groups
  set example_dir [file join $test_dir ".." "examples"]
  foreach test $tests {
    # Prune commented tests from the list.
    if { [string index $test 0] != "#" } {
      record_test $test $example_dir
    }
  }
}

################################################################

proc define_test_group { name tests } {
  global test_groups
  set test_groups($name) $tests
}

proc group_tests { name } {
  global test_groups
  return $test_groups($name)
}

# Clear the test lists.
proc clear_tests {} {
  global test_groups
  unset test_groups
}

proc list_delete { list delete } {
  set result {}
  foreach item $list {
    if { [lsearch $delete $item] == -1 } {
      lappend result $item
    }
  }
  return $result
}

################################################################

# Regression test lists.

# Record tests in sta/examples
record_example_tests {
  example1
  example2
  example3
  example4
  example5
}

define_test_group fast [group_tests all]
