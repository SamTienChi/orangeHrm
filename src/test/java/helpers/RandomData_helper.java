package helpers;
import java.util.Random;
import java.util.UUID;

public class RandomData_helper {
    public static String randomUUIShort(){
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return uuid.substring(0, 4); // chỉ lấy 4 ký tự đầu
    }

    public static int  randomNumber(){
        Random randomNumber = new Random();
        return randomNumber.nextInt(6000 - 1000 + 1) + 1000;
    }
}
