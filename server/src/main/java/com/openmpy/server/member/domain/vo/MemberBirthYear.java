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
public class MemberBirthYear {

    private Integer value;

    public MemberBirthYear(final Integer value) {
        validateBlank(value);

        this.value = value;
    }

    private void validateBlank(final Integer value) {
        if (value == null) {
            throw new IllegalArgumentException("나이가 빈 값일 수 없습니다.");
        }
    }
}
