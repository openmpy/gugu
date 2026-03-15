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
public class MemberComment {

    private static final int COMMENT_MAX_LENGTH = 100;

    private String value;

    public MemberComment(final String value) {
        validateBlank(value);
        validateLength(value);

        this.value = value;
    }

    private void validateBlank(final String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("코멘트 내용을 작성해주세요.");
        }
    }

    private void validateLength(final String value) {
        if (value.length() > COMMENT_MAX_LENGTH) {
            throw new IllegalArgumentException("코멘트 길이는 최대 100자까지 가능합니다.");
        }
    }
}
