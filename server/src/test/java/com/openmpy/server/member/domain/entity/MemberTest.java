package com.openmpy.server.member.domain.entity;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.constants.MemberStatus;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class MemberTest {

    @DisplayName("회원 객체를 생성한다.")
    @Test
    void member_test_01() {
        // given & when
        final Member member = Member.create(
            "01012345678",
            "홍길동",
            2000,
            MemberGender.MALE
        );

        // then
        assertThat(member.getPhone()).isEqualTo("01012345678");
        assertThat(member.getNickname()).isEqualTo("홍길동");
        assertThat(member.getBirthYear()).isEqualTo(2000);
        assertThat(member.getGender()).isEqualTo(MemberGender.MALE);
        assertThat(member.getStatus()).isEqualTo(MemberStatus.ACTIVE);
        assertThat(member.getCreatedAt()).isNotNull();
        assertThat(member.getUpdatedAt()).isNull();
        assertThat(member.getDeletedAt()).isNull();
    }

    @DisplayName("회원 정보를 수정한다.")
    @Test
    void member_test_02() {
        // given
        final Member member = Member.create(
            "01012345678",
            "홍길동",
            2000,
            MemberGender.MALE
        );

        // when
        member.update("박길동", 2003);

        // then
        assertThat(member.getNickname()).isEqualTo("박길동");
        assertThat(member.getBirthYear()).isEqualTo(2003);
    }

    @DisplayName("회원 탈퇴를 한다.")
    @Test
    void member_test_03() {
        // given
        final Member member = Member.create(
            "01012345678",
            "홍길동",
            2000,
            MemberGender.MALE
        );

        // when
        member.delete();

        // then
        assertThat(member.getStatus()).isEqualTo(MemberStatus.DELETED);
        assertThat(member.getDeletedAt()).isNotNull();
    }

    @DisplayName("탈퇴시 이미 탈퇴한 회원일 경우 예외가 발생한다.")
    @Test
    void exception_member_test_01() {
        // given
        final Member member = Member.create(
            "01012345678",
            "홍길동",
            2000,
            MemberGender.MALE
        );

        member.delete();

        // when & then
        assertThatThrownBy(member::delete)
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("이미 삭제된 계정입니다.");
    }
}