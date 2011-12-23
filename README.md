Buildpack Test Runner
=====================
A simple unit testing framework for testing buildpacks.
It provides utilities for loading buildpacks and capturing and asserting their behavior.
It is currently based on [shUnit2](http://code.google.com/p/shunit2/), but could be extended to support other testing frameworks.


Setup
-----
First clone this repository:

`git clone git@github.com:heroku/heroku-buildpack-testrunner.git`

If you do not already have shUnit2 installed, either [download](http://code.google.com/p/shunit2/downloads/list)
it or checkout it out from SVN:

`svn checkout http://shunit2.googlecode.com/svn/trunk/ shunit2`

Do not use `apt-get` for obtaining shUnit2 because it the wrong version.

Once you have shUnit2, set an `SHUNIT_HOME` environment variable to the root of the version you wish to use. For example:
`export SHUNIT_HOME=/usr/local/bin/shunit/source/2.1`

Usage
-----
To run the tests for one or more buildpacks, execute:

`bin/run [-c] buildpack_1 [buildpack_2 [...]]`

where `buildpack_n` can either be a local directory or a remote Git repository ending in `.git`.
Each buildpack must have a `test` directory and files matching the `*_test.sh` pattern to be run.
The `-c` flag enables persistent caching of files downloaded with cUrl. See `lib/magic_curl/README.md` for more info.

For example, the following command:

`bin/run ~/a_local_buildpack git@github.com:rbrainard/heroku-buildpack-gradle.git`

Would first run the tests in the buildpack at `~/a_local_buildpack` and then clone the
Git repository at `git@github.com:rbrainard/heroku-buildpack-gradle.git` into a temp
directory and run the tests there too.

Metatesting
-----------
The tests for the testrunner work just like any other buildpack. To test the testrunner itself, just run:

`bin/run .`

This can be helpful to make sure all the testrunner libraries work on your platform before testing any real buildpacks.

One caveat about negative tests for assertions is that they need to be captured and wrapped in paraenthesis to supress 
the assertion failure from causing the metatest to fail. For example, if you want to test that `assertContains` prints out
the proper failure message, capture, wrap, and then assert on the captured output.

    ( capture assertContains "xxx" "zookeeper" )
    assertEquals "ASSERT:Expected <zookeeper> to contain <xxx>" "`cat ${STD_OUT}`"
