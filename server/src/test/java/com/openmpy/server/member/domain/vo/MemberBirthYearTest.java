package com.openmpy.server.member.domain.vo;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullSource;

class MemberBirthYearTest {

    @DisplayName("회원 출생연도 객체를 생성한다.")
    @Test
    void member_birth_year_test_01() {
        // given & when
        final MemberBirthYear birthYear = new MemberBirthYear(2000);

        // then
        assertThat(birthYear.getValue()).isEqualTo(2000);
    }

    @DisplayName("출생연도가 빈 값일 경우 예외가 발생한다.")
    @ParameterizedTest(name = "입력 = {0}")
    @NullSource
    void exception_member_birth_year_test_01(final Integer input) {
        // when & then
        assertThatThrownBy(() -> new MemberBirthYear(input))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("나이가 빈 값일 수 없습니다.");
    }
}