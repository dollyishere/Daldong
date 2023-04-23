package com.ssafy.daldong.test;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/test")
public class TestController {

	@GetMapping("/helloworld")
	public String getHlloworld(){
		return "hellow, world!!!";
	}
}
