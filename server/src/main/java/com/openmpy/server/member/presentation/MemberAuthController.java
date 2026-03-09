package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.member.application.MemberAuthService;
import com.openmpy.server.member.dto.request.MemberDeleteRequest;
import com.openmpy.server.member.dto.request.MemberRotateTokenRequest;
import com.openmpy.server.member.dto.request.MemberSignupRequest;
import com.openmpy.server.member.dto.response.MemberRotateTokenResponse;
import com.openmpy.server.member.dto.response.MemberSignupResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api")
@RestController
public class MemberAuthController {

    private final MemberAuthService memberAuthService;

    @PostMapping("/v1/members/signup")
    public ResponseEntity<MemberSignupResponse> signup(
        @RequestBody final MemberSignupRequest request
    ) {
        final MemberSignupResponse response = memberAuthService.signup(request);
        return ResponseEntity.ok(response);
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
