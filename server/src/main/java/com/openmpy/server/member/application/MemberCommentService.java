package com.openmpy.server.member.application;

import com.openmpy.server.global.exception.CustomException;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.entity.MemberComment;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import com.openmpy.server.member.dto.response.MemberGetCommentResponse;
import com.openmpy.server.member.repository.MemberCommentRepository;
import com.openmpy.server.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberCommentService {

    private final MemberRepository memberRepository;
    private final MemberCommentRepository memberCommentRepository;

    @Transactional
    public void write(final Long memberId, final MemberWriteCommentRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);
        final MemberComment memberComment = MemberComment.create(member, request.content());

        memberCommentRepository.save(memberComment);
    }

    @Transactional(readOnly = true)
    public MemberGetCommentResponse get(final Long memberId) {
        final Member member = memberRepository.getReferenceById(memberId);
        final MemberComment memberComment = memberCommentRepository.findFirstByMemberOrderByUpdatedAtDesc(
                member
            )
            .orElseThrow(() -> new CustomException("코멘트를 작성해주시길 바랍니다."));

        memberCommentRepository.save(memberComment);
        return new MemberGetCommentResponse(
            memberComment.getContent(),
            memberComment.getUpdatedAt()
        );
    }
}
