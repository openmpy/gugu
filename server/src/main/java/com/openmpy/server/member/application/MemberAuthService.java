package com.openmpy.server.member.application;

import com.openmpy.server.auth.application.JwtService;
import com.openmpy.server.global.properties.JwtProperties;
import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberDeleteRequest;
import com.openmpy.server.member.dto.request.MemberRotateTokenRequest;
import com.openmpy.server.member.dto.request.MemberSignupRequest;
import com.openmpy.server.member.dto.response.MemberRotateTokenResponse;
import com.openmpy.server.member.dto.response.MemberSignupResponse;
import com.openmpy.server.member.repository.MemberRepository;
import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberAuthService {

    public static final String REFRESH_TOKEN_KEY = "auth:refresh_token:";

    private final MemberRepository memberRepository;
    private final StringRedisTemplate redisTemplate;

    private final JwtProperties jwtProperties;
    private final JwtService jwtService;

    @Transactional
    public MemberSignupResponse signup(final MemberSignupRequest request) {
        if (memberRepository.existsByPhone_Value(request.phone())) {
            throw new IllegalArgumentException("이미 가입된 휴대폰 번호입니다.");
        }
        if (memberRepository.existsByNickname_Value(request.nickname())) {
            throw new IllegalArgumentException("이미 가입된 닉네임입니다.");
        }

        final Member member = Member.create(
            request.phone(),
            request.nickname(),
            request.birthYear(),
            MemberGender.valueOf(request.gender())
        );

        memberRepository.save(member);

        final String accessToken = jwtService.generateAccessToken(member.getId());
        final String refreshToken = jwtService.generateRefreshToken();

        saveRefreshTokenToRedis(refreshToken, member.getId());
        return new MemberSignupResponse(accessToken, refreshToken);
    }

    @Transactional
    public MemberRotateTokenResponse rotateToken(final MemberRotateTokenRequest request) {
        final Long memberId = getMemberIdFromRefreshToken(request.refreshToken());

        removeRefreshTokenFromRedis(request.refreshToken());

        final String accessToken = jwtService.generateAccessToken(memberId);
        final String refreshToken = jwtService.generateRefreshToken();

        saveRefreshTokenToRedis(refreshToken, memberId);
        return new MemberRotateTokenResponse(accessToken, refreshToken);
    }

    @Transactional
    public void delete(final Long memberId, final MemberDeleteRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        member.delete();
        removeRefreshTokenFromRedis(request.refreshToken());
    }

    private void saveRefreshTokenToRedis(final String refreshToken, final Long memberId) {
        final String key = REFRESH_TOKEN_KEY + refreshToken;

        redisTemplate.opsForValue().set(
            key,
            String.valueOf(memberId),
            Duration.ofSeconds(jwtProperties.refreshTokenExpiration())
        );
    }

    private void removeRefreshTokenFromRedis(final String refreshToken) {
        final String key = REFRESH_TOKEN_KEY + refreshToken;

        redisTemplate.delete(key);
    }

    private Long getMemberIdFromRefreshToken(final String refreshToken) {
        final String key = REFRESH_TOKEN_KEY + refreshToken;
        final String memberId = redisTemplate.opsForValue().get(key);

        if (memberId == null) {
            throw new IllegalArgumentException("회원 ID 값을 찾을 수 없습니다.");
        }

        return Long.valueOf(memberId);
    }
}
