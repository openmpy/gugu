package com.openmpy.server.member.dto.request;

public record MemberVerifyCodeRequest(
    String phone,
    String code
) {

}
