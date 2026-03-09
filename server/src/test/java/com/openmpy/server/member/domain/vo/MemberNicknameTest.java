package com.openmpy.server.member.domain.vo;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;

class MemberNicknameTest {

    @DisplayName("회원 닉네임 객체를 생성한다.")
    @Test
    void member_nickname_test_01() {
        // given & when
        final MemberNickname nickname = new MemberNickname("홍길동");

        // then
        assertThat(nickname.getValue()).isEqualTo("홍길동");
    }

    @DisplayName("닉네임이 빈 값일 경우 예외가 발생한다.")
    @ParameterizedTest(name = "입력 = {0}")
    @NullAndEmptySource
    void exception_member_nickname_test_01(final String input) {
        // when & then
        assertThatThrownBy(() -> new MemberNickname(input))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("닉네임이 빈 값일 수 없습니다.");
    }

    @DisplayName("닉네임 길이가 10자를 넘어갈 경우 예외가 발생한다.")
    @Test
    void exception_member_nickname_test_02() {
        // when & then
        assertThatThrownBy(() -> new MemberNickname("1234567890*"))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("닉네임 길이는 최대 10자까지 가능합니다.");
    }
}