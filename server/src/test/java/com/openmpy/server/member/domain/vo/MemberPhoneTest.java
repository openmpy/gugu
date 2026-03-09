package com.openmpy.server.member.domain.vo;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;

class MemberPhoneTest {

    @DisplayName("회원 휴대폰 번호 객체를 생성한다.")
    @Test
    void member_phone_test_01() {
        // given & when
        final MemberPhone phone = new MemberPhone("01012345678");

        // then
        assertThat(phone.getValue()).isEqualTo("01012345678");
    }

    @DisplayName("번호가 빈 값일 경우 예외가 발생한다.")
    @ParameterizedTest(name = "입력 = {0}")
    @NullAndEmptySource
    void exception_member_phone_test_01(final String input) {
        // when & then
        assertThatThrownBy(() -> new MemberPhone(input))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("휴대폰 번호가 빈 값일 수 없습니다.");
    }

    @DisplayName("번호 형식이 올바르지 않을 경우 예외가 발생한다.")
    @ParameterizedTest(name = "입력 = {0}")
    @ValueSource(strings = {"010-1234-5678", "01112345678", "010", "abc", "!@#"})
    void exception_member_phone_test_02(final String input) {
        // when & then
        assertThatThrownBy(() -> new MemberPhone(input))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("휴대폰 번호 형식이 올바르지 않습니다.");
    }
}