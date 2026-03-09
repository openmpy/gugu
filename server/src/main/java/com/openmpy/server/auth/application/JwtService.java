package com.openmpy.server.auth.application;

import com.openmpy.server.global.properties.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.UnsupportedJwtException;
import java.util.Date;
import java.util.Map;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@RequiredArgsConstructor
@Service
public class JwtService {

    public static final String MEMBER_ID = "id";

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

    public boolean validateToken(final String token) {
        try {
            Jwts.parser().setSigningKey(jwtProperties.secretKey()).parseClaimsJws(token);
            return true;
        } catch (final ExpiredJwtException e) {
            log.warn("토큰이 만료되었습니다. {}", e.getMessage());
        } catch (final UnsupportedJwtException e) {
            log.warn("지원되지 않는 토큰입니다. {}", e.getMessage());
        } catch (final MalformedJwtException e) {
            log.warn("형식이 잘못된 토큰입니다. {}", e.getMessage());
        } catch (final SecurityException e) {
            log.warn("유효하지 않은 서명입니다. {}", e.getMessage());
        } catch (final IllegalArgumentException e) {
            log.warn("토큰 클레임이 비어 있습니다. {}", e.getMessage());
        }
        return false;
    }

    public Long extractMemberId(final String accessToken) {
        final Map<String, Object> payload = getPayload(accessToken);
        return Long.valueOf(payload.get(MEMBER_ID).toString());
    }

    private Map<String, Long> createClaims(final Long memberId) {
        return Map.of("id", memberId);
    }

    private Map<String, Object> getPayload(final String token) {
        return Jwts.parser()
            .setSigningKey(jwtProperties.secretKey())
            .parseClaimsJws(token)
            .getBody();
    }
}
