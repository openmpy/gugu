package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.global.dto.CursorResponse;
import com.openmpy.server.member.application.MemberService;
import com.openmpy.server.member.dto.request.MemberUpdateLocationRequest;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import com.openmpy.server.member.dto.response.MemberGetCommentResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api")
@RestController
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/v1/members/comments")
    public ResponseEntity<Void> writeComment(
        @Login final Long memberId,
        @RequestBody final MemberWriteCommentRequest request
    ) {
        memberService.writeComment(memberId, request);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/v1/members/comments")
    public ResponseEntity<CursorResponse<MemberGetCommentResponse>> getComments(
        @Login final Long memberId,
        @RequestParam(value = "gender", defaultValue = "ALL") final String gender,
        @RequestParam(value = "cursorId", required = false) final Long cursorId,
        @RequestParam(value = "size", defaultValue = "15") final int size
    ) {
        final CursorResponse<MemberGetCommentResponse> response = memberService.getComments(
            memberId,
            gender,
            cursorId,
            size
        );

        return ResponseEntity.ok(response);
    }

    @PutMapping("/v1/members/comments/bump")
    public ResponseEntity<Void> bumpComment(
        @Login final Long memberId
    ) {
        memberService.bumpComment(memberId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/v1/members/location")
    public ResponseEntity<Void> updateLocation(
        @Login final Long memberId,
        @RequestBody final MemberUpdateLocationRequest request
    ) {
        memberService.updateLocation(memberId, request);
        return ResponseEntity.noContent().build();
    }
}
