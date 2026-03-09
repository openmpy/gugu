package com.openmpy.server.auth.application;

import com.openmpy.server.global.properties.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import java.util.Date;
import java.util.Map;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class JwtService {

    private final JwtProperties jwtProperties;

    public String generateAccessToken(final Long memberId) {
        final Claims jwtClaims = Jwts.claims();
        final Map<String, Long> claims = createClaims(memberId);

        jwtClaims.putAll(claims);

        final Date now = new Date();
        final Date expiration = new Date(
            now.getTime() + jwtProperties.accessTokenExpiration() * 1000
        );

        return Jwts.builder()
            .setClaims(jwtClaims)
            .setIssuedAt(now)
            .setExpiration(expiration)
            .signWith(SignatureAlgorithm.HS256, jwtProperties.secretKey())
            .compact();
    }

    public String generateRefreshToken() {
        return UUID.randomUUID().toString();
    }

    private Map<String, Long> createClaims(final Long memberId) {
        return Map.of("id", memberId);
    }
}
