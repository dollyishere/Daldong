package com.ssafy.daldong.global.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.bind.annotation.RestController;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class SwaggerConfig {
    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class)) // basic-error-controller 제외
                .paths(PathSelectors.any())
                .build()
                .pathMapping("/test/api");
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("달려동물")
                .version("1.0")
                .description("달려동물 API 문서입니다")
                .build();
    }
}