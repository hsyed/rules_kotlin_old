@file:JvmName("Main")
package helloworld

import java.nio.file.Paths

fun main(args :Array<String>) {
    if(!Paths.get("tests", "smoke", "data" ,"datafile.txt").toFile().exists()) {
        System.err.println("could not read datafile")
        System.exit(1)
    }
    println("bang bang")
    System.out.println("boom")
}