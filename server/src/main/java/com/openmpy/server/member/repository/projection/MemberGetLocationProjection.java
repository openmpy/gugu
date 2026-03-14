package com.openmpy.server.member.repository.projection;

import java.time.LocalDateTime;

public record MemberGetLocationProjection(
    Long memberId,
    String nickname,
    String gender,
    Integer birthYear,
    Double distance,
    String bio,
    LocalDateTime updatedAt
) {

}
