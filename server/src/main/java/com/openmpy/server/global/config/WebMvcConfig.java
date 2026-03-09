package com.openmpy.server.global.config;

import com.openmpy.server.auth.application.JwtService;
import com.openmpy.server.auth.infrastructure.AuthenticationPrincipalArgumentResolver;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@RequiredArgsConstructor
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final JwtService jwtService;

    @Override
    public void addArgumentResolvers(final List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(argumentResolver());
    }

    private AuthenticationPrincipalArgumentResolver argumentResolver() {
        return new AuthenticationPrincipalArgumentResolver(jwtService);
    }
}
