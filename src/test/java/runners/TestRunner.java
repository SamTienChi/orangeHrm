package runners;
import static org.junit.jupiter.api.Assertions.*;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

public class TestRunner {
    @Test
    void runTest(){
        Results results = Runner.path("classpath:features")
                .tags("~@ignore")
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    @Test
    void runConfig(){
        Results results = Runner.path("classpath:utils/Auth/auth.feature")
                        .parallel(1);
                assertEquals(0, results.getFailCount(), results.getErrorMessages());

    }
}
