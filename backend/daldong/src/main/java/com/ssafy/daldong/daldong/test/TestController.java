package com.ssafy.daldong.daldong.test;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {

	@GetMapping("/print")
	public String getHelloworld(){
		return "Hello, world!";
	}
}
