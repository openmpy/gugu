package com.openmpy.server.member.dto.response;

import java.time.LocalDateTime;

public record MemberGetCommentResponse(
    Long memberId,
    String content,
    LocalDateTime updatedAt
) {

}
