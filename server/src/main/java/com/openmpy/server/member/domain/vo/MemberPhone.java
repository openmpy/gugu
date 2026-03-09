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
public class MemberPhone {

    public static final String PHONE_NUMBER_REGEX = "^010\\d{8}$";

    private String value;

    public MemberPhone(final String value) {
        validateBlank(value);
        validateNumber(value);

        this.value = value;
    }

    private void validateBlank(final String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("휴대폰 번호가 빈 값일 수 없습니다.");
        }
    }

    private void validateNumber(final String value) {
        if (!value.matches(PHONE_NUMBER_REGEX)) {
            throw new IllegalArgumentException("휴대폰 번호 형식이 올바르지 않습니다.");
        }
    }
}
