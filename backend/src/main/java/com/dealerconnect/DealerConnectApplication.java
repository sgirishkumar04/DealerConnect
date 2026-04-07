package com.dealerconnect;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication
@EnableCaching
public class DealerConnectApplication {
    public static void main(String[] args) {
        SpringApplication.run(DealerConnectApplication.class, args);
    }
}
