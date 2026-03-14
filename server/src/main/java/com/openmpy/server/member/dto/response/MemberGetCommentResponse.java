package com.openmpy.server.member.dto.response;

import com.openmpy.server.member.domain.constants.MemberGender;
import java.time.LocalDateTime;

public record MemberGetCommentResponse(
    Long memberId,
    String nickname,
    MemberGender gender,
    Integer age,
    Integer heartCount,
    Double distance,
    String comment,
    LocalDateTime updatedAt
) {

}
