package com.openmpy.server.member.domain.vo;

import jakarta.persistence.Embeddable;
import lombok.AccessLevel;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

@EqualsAndHashCode
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Embeddable
public class MemberNickname {

    public static final int NICKNAME_MAX_LENGTH = 10;

    private String value;

    public MemberNickname(final String value) {
        validateBlank(value);
        validateLength(value);

        this.value = value;
    }

    private void validateBlank(final String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("닉네임이 빈 값일 수 없습니다.");
        }
    }

    private void validateLength(final String value) {
        if (value.length() > NICKNAME_MAX_LENGTH) {
            throw new IllegalArgumentException("닉네임 길이는 최대 10자까지 가능합니다.");
        }
    }
}
