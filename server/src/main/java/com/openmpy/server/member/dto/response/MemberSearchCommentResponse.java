package com.openmpy.server.member.dto.response;

import com.openmpy.server.member.domain.constants.MemberGender;
import java.time.LocalDateTime;

public record MemberSearchCommentResponse(
    Long memberId,
    String nickname,
    MemberGender gender,
    Integer age,
    String comment,
    LocalDateTime updatedAt
) {

}
