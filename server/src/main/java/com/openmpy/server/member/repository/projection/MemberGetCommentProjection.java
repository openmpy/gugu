package com.openmpy.server.member.repository.projection;

import java.time.LocalDateTime;

public record MemberGetCommentProjection(
    Long memberId,
    String nickname,
    String gender,
    Integer birthYear,
    Double distance,
    String comment,
    LocalDateTime updatedAt
) {

}
