package tests.smoke.junittest

import org.junit.*
import org.junit.runner.RunWith
import org.junit.runners.Suite
import java.nio.file.Paths


//@RunWith(Suite::class)
class JunitTest {
    @Test
    fun dummyTest() {
        if(!Paths.get("tests", "smoke", "data" ,"datafile.txt").toFile().exists()) {
            throw RuntimeException("could not read datafile")

        }
    }

//    @Test
//    fun failingTest() {
//        throw RuntimeException("boom")
//    }
}