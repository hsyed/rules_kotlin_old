package testing;

import org.junit.Test;


public class CompileTimeDependent {
    @Test
    public void justSoIcanUseTheTestAnnotation() {

    }

    public static void main(String[] args) {
        new Stub();
    }
}