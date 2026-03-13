package com.openmpy.server.member.dto.request;

import com.openmpy.server.member.domain.constants.MemberGender;

public record MemberVerifyCodeRequest(
    String phone,
    String code,
    String password,
    MemberGender gender
) {

}
