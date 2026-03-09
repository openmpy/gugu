package com.openmpy.server.member.application;

import com.openmpy.server.auth.application.JwtService;
import com.openmpy.server.global.properties.JwtProperties;
import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberSignupRequest;
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

    private void saveRefreshTokenToRedis(final String refreshToken, final Long memberId) {
        final String key = "refresh-token:" + refreshToken;

        redisTemplate.opsForValue().set(
            key,
            String.valueOf(memberId),
            Duration.ofSeconds(jwtProperties.refreshTokenExpiration())
        );
    }
}
