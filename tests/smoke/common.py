import os
import subprocess
import unittest
import zipfile

import sys

DEVNULL = open(os.devnull, 'wb')

REPO_ROOT = "org_pubref_rules_kotlin"
TEST_BASE = "tests/smoke"


def _target(target_name):
    return "//%s:%s" % (TEST_BASE, target_name)


def _bazel_bin(file):
    return "bazel-bin/" + TEST_BASE + "/" + file


def _open_bazel_bin(file):
    return open(_bazel_bin(file))


class BazelKotlinTestCase(unittest.TestCase):
    def _query(self, query, implicits=False):
        res = []
        q = ['bazel', 'query', query]
        if not implicits:
            q.append('--noimplicit_deps')
        self._last_command = " ".join(q)

        p = subprocess.Popen(self._last_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        for line in p.stdout.readlines():
            res.append(line.replace("\n", ""))
        ret = p.wait()
        if ret != 0:
            raise Exception("error (%d) evaluating query: %s" % (ret, self._last_command))
        else:
            return res

    def libQuery(self, label, implicits=False):
        return self._query('\'kind("java_import|.*_library", deps(%s))\'' % label, implicits)

    def assertJarContains(self, jar, *files):
        curr = ""
        try:
            for f in files:
                curr = f
                jar.getinfo(f)
        except Exception as ex:
            raise Exception("jar does not contain file [%s]" % curr)

    def buildJar(self, target, silent=True):
        target = _target(target)
        build = ["bazel", "build", target]
        print(" ".join(build))
        out = sys.stdout
        if silent:
            out = DEVNULL
        subprocess.call(build, stdout=out, stderr=out)

    def buildJarGetZipFile(self, name, extension):
        jar_file = name + "." + extension
        self.buildJar(jar_file)
        return zipfile.ZipFile(_open_bazel_bin(jar_file))

    def buildLaunchExpectingSuccess(self, target, command="run"):
        self.buildJar(target, silent=False)
        res = subprocess.call(["bazel", command, _target(target)], stdout=sys.stdout, stderr=sys.stdout)
        if not res == 0:
            raise Exception("could not launch jar [%s]" % target)
