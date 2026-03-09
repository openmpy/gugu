package com.openmpy.server.member.dto.request;

import com.openmpy.server.member.domain.constants.MemberGender;

public record MemberActivateRequest(
    String nickname,
    Integer birthYear,
    MemberGender gender,
    String bio
) {

}
