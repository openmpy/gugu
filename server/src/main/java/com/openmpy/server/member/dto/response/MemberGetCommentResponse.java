package com.openmpy.server.member.dto.response;

import java.time.LocalDateTime;

public record MemberGetCommentResponse(
    String content,
    LocalDateTime updatedAt
) {

}
