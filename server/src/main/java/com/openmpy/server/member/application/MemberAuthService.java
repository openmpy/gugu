package com.openmpy.server.member.application;

import static com.openmpy.server.auth.application.JwtService.BLACKLIST_ACCESS_TOKEN_KEY;

import com.openmpy.server.auth.application.JwtService;
import com.openmpy.server.global.properties.JwtProperties;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberActivateRequest;
import com.openmpy.server.member.dto.request.MemberDeleteRequest;
import com.openmpy.server.member.dto.request.MemberRotateTokenRequest;
import com.openmpy.server.member.dto.request.MemberSendCodeRequest;
import com.openmpy.server.member.dto.request.MemberVerifyCodeRequest;
import com.openmpy.server.member.dto.response.MemberRotateTokenResponse;
import com.openmpy.server.member.dto.response.MemberVerifyCodeResponse;
import com.openmpy.server.member.repository.MemberRepository;
import java.time.Duration;
import java.util.concurrent.ThreadLocalRandom;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberAuthService {

    public static final String PHONE_KEY = "auth:phone:";
    public static final String REFRESH_TOKEN_KEY = "auth:refresh_token:";
    public static final int CODE_EXPIRE_MINUTES = 3;

    private final MemberRepository memberRepository;
    private final StringRedisTemplate redisTemplate;

    private final JwtProperties jwtProperties;
    private final JwtService jwtService;

    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public void sendCode(final MemberSendCodeRequest request) {
        if (Boolean.TRUE.equals(redisTemplate.hasKey(PHONE_KEY + request.phone()))) {
            throw new IllegalArgumentException("인증 번호가 이미 전송되었습니다.");
        }

        final String key = PHONE_KEY + request.phone();
        final String code = generateCode();

        redisTemplate.opsForValue().set(key, code, Duration.ofMinutes(CODE_EXPIRE_MINUTES));
        System.out.println("code = " + code); // SMS API 호출
    }

    @Transactional
    public MemberVerifyCodeResponse verifyCode(final MemberVerifyCodeRequest request) {
        final String key = PHONE_KEY + request.phone();
        final String savedCode = redisTemplate.opsForValue().get(key);

        if (savedCode == null) {
            throw new IllegalArgumentException("인증 번호가 존재하지 않습니다.");
        }
        if (!savedCode.equals(request.code())) {
            throw new IllegalArgumentException("인증 번호가 일치하지 않습니다.");
        }
        if (memberRepository.existsByPhone_Value(request.phone())) {
            throw new IllegalArgumentException("이미 가입된 휴대폰 번호입니다.");
        }

        final String password = passwordEncoder.encode(request.password());
        final Member member = Member.create(request.phone(), password);

        memberRepository.save(member);

        final String accessToken = jwtService.generateAccessToken(member.getId());
        final String refreshToken = jwtService.generateRefreshToken();

        saveRefreshTokenToRedis(refreshToken, member.getId());
        redisTemplate.delete(key);

        return new MemberVerifyCodeResponse(accessToken, refreshToken);
    }

    @Transactional
    public void activate(final Long memberId, final MemberActivateRequest request) {
        if (memberRepository.existsByNickname_Value(request.nickname())) {
            throw new IllegalArgumentException("이미 가입된 닉네임입니다.");
        }

        final Member member = getMember(memberId);

        member.activate(request.nickname(), request.birthYear(), request.gender(), request.bio());
    }

    @Transactional
    public MemberRotateTokenResponse rotateToken(final MemberRotateTokenRequest request) {
        final Long memberId = getMemberIdFromRefreshToken(request.refreshToken());

        addBlacklistedAccessToken(request.accessToken());
        removeRefreshTokenFromRedis(request.refreshToken());

        final String accessToken = jwtService.generateAccessToken(memberId);
        final String refreshToken = jwtService.generateRefreshToken();

        saveRefreshTokenToRedis(refreshToken, memberId);
        return new MemberRotateTokenResponse(accessToken, refreshToken);
    }

    @Transactional
    public void delete(final Long memberId, final MemberDeleteRequest request) {
        final Member member = getMember(memberId);

        member.delete();
        addBlacklistedAccessToken(request.accessToken());
        removeRefreshTokenFromRedis(request.refreshToken());
    }

    private Member getMember(final Long memberId) {
        return memberRepository.getReferenceById(memberId);
    }

    private String generateCode() {
        return String.format("%06d", ThreadLocalRandom.current().nextInt(1_000_000));
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

    private void addBlacklistedAccessToken(final String accessToken) {
        redisTemplate.opsForValue().set(
            BLACKLIST_ACCESS_TOKEN_KEY + accessToken,
            "1",
            Duration.ofSeconds(jwtProperties.accessTokenExpiration())
        );
    }
}
