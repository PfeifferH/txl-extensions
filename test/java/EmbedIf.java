class EmbedIf
{
    public static void main(String args[])
    {
        int x = 1;
        System.out.println("Start");

        if (x == 1) {
            System.out.println("Begin Embed");
            int y = 0;
            System.out.println("End Embed");
        }

        System.out.println("End");
    }
}