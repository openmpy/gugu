package com.openmpy.server.global.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("app.jwt")
public record JwtProperties(
    String secretKey,
    Long accessTokenExpiration,
    Long refreshTokenExpiration
) {

}
