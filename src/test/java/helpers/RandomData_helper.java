package helpers;
import java.util.UUID;

public class RandomData_helper {
    public static String randomUUIShort(){
        String uuid = UUID.randomUUID().toString().replace("-", "");
        return uuid.substring(0, 4); // chỉ lấy 4 ký tự đầu
    }
}
