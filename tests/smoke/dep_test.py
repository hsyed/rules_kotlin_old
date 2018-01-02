import subprocess
import unittest

import os

from common import BazelKotlinTestCase


class TestRules(BazelKotlinTestCase):
    def test_resources_no_strip(self):
        jar = self.buildJarGetZipFile("testresources", "jar")
        self.assertJarContains(jar,"one/two/aFile.txt","one/alsoAFile.txt")
        self.assertJarContains(jar, "c/pkg/X.class", "c/pkg/SecondFile.class", "c/pkg/ThirdClass.class")

    # # TODO what are the kotlin src jar conventions ?
    # def test_srcjar(self):
    #     jar = self.buildJarGetZipFile("testresources", "srcjar")
    #     self.assertJarContains(jar, "testresources/SecondFile.kt", "testresources/ConsumerLib.kt")

    def test_test_targets_launch_correctly(self):
        self.buildLaunchExpectingSuccess("junittest", command="test")

    def test_bin_targets_launch_correctly(self):
        self.buildLaunchExpectingSuccess("helloworld")


if __name__ == '__main__':
    os.chdir(subprocess.check_output(['bazel', 'info', 'workspace']).replace("\n", ""))
    unittest.main()
