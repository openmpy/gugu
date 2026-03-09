package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.member.application.MemberLocationService;
import com.openmpy.server.member.dto.request.MemberUpsertLocationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api/v1")
@RestController
public class MemberLocationController {

    private final MemberLocationService memberLocationService;

    @PostMapping("/members/location")
    public ResponseEntity<Void> upsertLocation(
        @Login final Long memberId,
        @RequestBody final MemberUpsertLocationRequest request
    ) {
        memberLocationService.upsertLocation(memberId, request);
        return ResponseEntity.noContent().build();
    }
}
