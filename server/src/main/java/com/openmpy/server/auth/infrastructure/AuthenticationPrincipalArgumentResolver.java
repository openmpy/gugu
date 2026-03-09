package com.openmpy.server.auth.infrastructure;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.auth.application.JwtService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;
import org.springframework.web.server.ResponseStatusException;

@RequiredArgsConstructor
public class AuthenticationPrincipalArgumentResolver implements HandlerMethodArgumentResolver {

    private final JwtService jwtService;

    @Override
    public boolean supportsParameter(final MethodParameter parameter) {
        return parameter.hasParameterAnnotation(Login.class)
            && parameter.getParameterType().equals(Long.class);
    }

    @Override
    public @Nullable Object resolveArgument(
        final MethodParameter parameter,
        @Nullable final ModelAndViewContainer mavContainer,
        final NativeWebRequest webRequest,
        @Nullable final WebDataBinderFactory binderFactory
    ) throws Exception {
        final HttpServletRequest servletRequest = webRequest.getNativeRequest(
            HttpServletRequest.class
        );
        final String accessToken = AuthenticationExtractor.extract(servletRequest);

        if (accessToken == null) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN);
        }
        if (!jwtService.validateToken(accessToken)) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        }
        return jwtService.extractMemberId(accessToken);
    }
}
