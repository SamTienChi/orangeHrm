function fn() {
    var env = karate.env || 'dev';
    var envConfig = karate.read('classpath:config/dev.yaml');

    var config = karate.merge(envConfig);

    karate.configure('cookies', true);
    var result = karate.callSingle('classpath:utils/Auth/auth.feature', config);

    if(result){
        karate.configure('headers', {
          'Content-Type': 'application/json',
          'Cookie': result.cookies
        });
        config.cookies = result.cookies;
        karate.log("Cookie header config success:", config.cookies)
    }else{
        karate.fail("Login failed - no cookie returned");
    }

    return config;
}