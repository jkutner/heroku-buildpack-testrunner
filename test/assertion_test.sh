#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testAssertContains_Beginning()
{
  assertContains "zoo" "zookeeper"
}

testAssertContains_Middle()
{
  assertContains "keep" "zookeeper"
}

testAssertContains_End()
{
  assertContains "er" "zookeeper"
}

testAssertContains_Multiline()
{
  haystack=`cat <<EOF
Little Bo Peep
had lost her sheep
EOF`

  assertContains "her" "${haystack}"
}

testAssertContains_DefaultMessageOnFailure()
{
  ( capture assertContains "xxx" "zookeeper" )
  assertEquals "ASSERT:Expected <zookeeper> to contain <xxx>" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
  assertEquals "" "${rtrn}"
}


testAssertNotContains()
{
  assertNotContains "book" "zookeeper"
}

testAssertNotContains_Multiline()
{
  haystack=`cat <<EOF
Little Bo Peep
had lost her sheep
EOF`

  assertNotContains "goat" "${haystack}"
}

testAssertNotContains_DefaultMessageOnFailure()
{
  ( capture assertNotContains "keep" "zookeeper" )
  assertEquals "ASSERT:Did not expect <zookeeper> to contain <keep>" "`cat ${STD_OUT}`"
  assertEquals "" "`cat ${STD_ERR}`"
  assertEquals "" "${rtrn}"
}


testMD5()
{
  touch ${OUTPUT_DIR}/salty
  assertFileMD5 "d41d8cd98f00b204e9800998ecf8427e" "${OUTPUT_DIR}/salty"
}


testMD5_Failure()
{
  touch ${OUTPUT_DIR}/salty
  ( capture assertFileMD5 "INVALIID_MD5" "${OUTPUT_DIR}/salty" )
  assertEquals "ASSERT:expected:<MD5 (${OUTPUT_DIR}/salty) = INVALIID_MD5> but was:<MD5 (${OUTPUT_DIR}/salty) = d41d8cd98f00b204e9800998ecf8427e>" "`cat ${STD_OUT}`"
}