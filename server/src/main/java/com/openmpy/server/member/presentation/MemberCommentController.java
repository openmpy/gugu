package com.openmpy.server.member.presentation;

import com.openmpy.server.auth.annotation.Login;
import com.openmpy.server.member.application.MemberCommentService;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RequestMapping("/api")
@RestController
public class MemberCommentController {

    private final MemberCommentService memberCommentService;

    @PostMapping("/v1/members/comments")
    public ResponseEntity<Void> write(
        @Login final Long memberId,
        @RequestBody final MemberWriteCommentRequest request
    ) {
        memberCommentService.write(memberId, request);
        return ResponseEntity.noContent().build();
    }
}
