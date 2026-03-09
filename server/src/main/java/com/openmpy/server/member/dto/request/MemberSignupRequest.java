package com.openmpy.server.member.dto.request;

public record MemberSignupRequest(
    String phone,
    String nickname,
    Integer birthYear,
    String gender
) {

}
