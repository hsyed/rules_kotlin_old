/*
 * Copyright 2018 The Bazel Authors. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.bazel.ruleskotlin.workers.compilers.jvm;

import java.util.Arrays;
import java.util.EnumMap;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class BuildContext {
    public enum Field {
        LABEL("--label", null, true),
        OUTPUT_CLASSJAR("--output_classjar", "-d", true),
        OUTPUT_JDEPS("--output_jdeps", null, true),
        CLASSPATH("--classpath", "-cp", true),
        SOURCES("--sources", null, true),
        KOTLIN_API_VERSION("--kotlin_api_version", "-api-version", false),
        KOTLIN_LANGUAGE_VERSION("--kotlin_language_version", "-language-version", false),
        KOTLIN_JVM_TARGET("--kotlin_jvm_target", "-jvm-target", false);

        public final String name;
        public final String kotlinName;
        final boolean mandatory;

        Field(String name, String kotlinName, boolean mandatory) {
            this.name = name;
            this.kotlinName = kotlinName;
            this.mandatory = mandatory;
        }

        public String get(BuildContext context) {
            return context.get(this);
        }
    }

    private static final Map<String, Field> ALL_FIELDS_MAP = Arrays.stream(Field.values()).collect(Collectors.toMap(x -> x.name, x->x));
    private static final Field[] MANDATORY_FIELDS = Arrays.stream(Field.values()).filter(x->x.mandatory).toArray(Field[]::new);

    private final EnumMap<Field, String> args;

    private BuildContext(String[] args) {
        this.args = new EnumMap<>(Field.class);

        if(args.length %2 != 0) {
            throw new RuntimeException("args should be k,v pairs");
        }

        for (int i = 0; i < args.length / 2; i++) {
            String flag = args[i * 2];
            String value = args[(i * 2) + 1];
            Field field = ALL_FIELDS_MAP.get(flag);
            if(field == null) {
                throw new RuntimeException("unrecognised arg: " + flag);
            }
            this.args.put(field, value);
        }

        for (Field mandatoryField : MANDATORY_FIELDS) {
            if(!this.args.containsKey(mandatoryField)) {
                throw new RuntimeException("mandatory arg missing: " + mandatoryField.name);
            }
        }
    }

    public static BuildContext from(Stream<String> args) {
        return new BuildContext(args.toArray(String[]::new));
    }

    private String get(Field field) {
        return args.get(field);
    }
}
