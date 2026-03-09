package com.openmpy.server.auth.application;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;

@SpringBootTest(webEnvironment = WebEnvironment.NONE)
class JwtServiceTest {

    @Autowired
    private JwtService jwtService;

    @DisplayName("Access Token을 생성한다.")
    @Test
    void jwt_service_test_01() {
        // given & when
        final String accessToken = jwtService.generateAccessToken(1L);

        // then
        assertThat(accessToken).isNotNull();
        System.out.println("accessToken = " + accessToken);
    }

    @DisplayName("Refresh Token을 생성한다.")
    @Test
    void jwt_service_test_02() {
        // given & when
        final String refreshToken = jwtService.generateRefreshToken();

        // then
        assertThat(refreshToken).isNotNull();
        System.out.println("refreshToken = " + refreshToken);
    }
}