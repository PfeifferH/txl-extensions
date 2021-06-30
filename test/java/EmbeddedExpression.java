class main
{
    public static void main(String args[])
    {
        System.out.println("Start");

        int x = 6 + 7;

        if (x < 0) {
            x = 0;
        }
        if (x > 8 - 5) {
            x = 8 - 5;
        }

        System.out.println(x);

        System.out.println("End");
    }
}