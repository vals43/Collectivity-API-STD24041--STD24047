package com.collectivity.agricultural.exeption;

public class GlobalExeptionHandler extends RuntimeException {
    public GlobalExeptionHandler(String message) {
        super(message);
    }
}
