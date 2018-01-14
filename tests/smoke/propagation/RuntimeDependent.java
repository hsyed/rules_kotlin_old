package testing;

public class RuntimeDependent {
    public static void main(String[] args) {
        try {
            Class.forName("org.junit.Test");
        } catch (ClassNotFoundException e) {
            System.exit(1);
        }
        System.exit(0);
    }
}
