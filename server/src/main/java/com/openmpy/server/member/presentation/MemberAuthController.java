package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.member.application.MemberAuthService;
import com.openmpy.server.member.dto.request.MemberActivateRequest;
import com.openmpy.server.member.dto.request.MemberDeleteRequest;
import com.openmpy.server.member.dto.request.MemberRotateTokenRequest;
import com.openmpy.server.member.dto.request.MemberSendCodeRequest;
import com.openmpy.server.member.dto.request.MemberVerifyCodeRequest;
import com.openmpy.server.member.dto.response.MemberRotateTokenResponse;
import com.openmpy.server.member.dto.response.MemberVerifyCodeResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api")
@RestController
public class MemberAuthController {

    private final MemberAuthService memberAuthService;

    @PostMapping("/v1/members/phone/send-code")
    public ResponseEntity<Void> sendCode(
        @RequestBody final MemberSendCodeRequest request
    ) {
        memberAuthService.sendCode(request);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/v1/members/phone/verify-code")
    public ResponseEntity<MemberVerifyCodeResponse> verify(
        @RequestBody final MemberVerifyCodeRequest request
    ) {
        final MemberVerifyCodeResponse response = memberAuthService.verifyCode(request);
        return ResponseEntity.ok(response);
    }

    @PutMapping("/v1/members/activate")
    public ResponseEntity<Void> activate(
        @Login final Long memberId,
        @RequestBody final MemberActivateRequest request
    ) {
        memberAuthService.activate(memberId, request);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/v1/members/token")
    public ResponseEntity<MemberRotateTokenResponse> rotateToken(
        @RequestBody final MemberRotateTokenRequest request
    ) {
        final MemberRotateTokenResponse response = memberAuthService.rotateToken(request);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/v1/members")
    public ResponseEntity<Void> delete(
        @Login final Long memberId,
        @RequestBody final MemberDeleteRequest request
    ) {
        memberAuthService.delete(memberId, request);
        return ResponseEntity.noContent().build();
    }
}
