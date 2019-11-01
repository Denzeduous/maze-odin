@ECHO OFF
cls
odin build .
odin run . -- utest/testfile.txt utest/fulltest.txt