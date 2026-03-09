package com.openmpy.server.member.presentation;

import com.openmpy.server.member.application.MemberAuthService;
import com.openmpy.server.member.dto.request.MemberSignupRequest;
import com.openmpy.server.member.dto.response.MemberSignupResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
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
}
