package com.openmpy.server.member.application;

import com.openmpy.server.global.dto.CursorResponse;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import com.openmpy.server.member.dto.response.MemberGetCommentResponse;
import com.openmpy.server.member.repository.MemberRepository;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberService {

    private final MemberRepository memberRepository;

    @Transactional
    public void writeComment(final Long memberId, final MemberWriteCommentRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        member.writeComment(request.comment());
    }

    @Transactional(readOnly = true)
    public CursorResponse<MemberGetCommentResponse> getComments(
        final Long memberId,
        final Long cursorId,
        final Integer size
    ) {
        final List<Member> members = memberRepository.findAllByIdWithCursor(
            memberId,
            cursorId,
            PageRequest.of(0, size + 1)
        );

        final boolean hasNext = members.size() > size;

        final List<Member> pageMembers = hasNext ? members.subList(0, size) : members;
        final List<MemberGetCommentResponse> commentResponses = pageMembers.stream()
            .map(it -> new MemberGetCommentResponse(
                it.getId(),
                it.getNickname(),
                it.getGender(),
                LocalDate.now().getYear() - it.getBirthYear(),
                100,
                25.12,
                it.getComment(),
                it.getUpdatedAt()
            ))
            .toList();

        final Long nextCursor = hasNext ? pageMembers.getLast().getId() : null;

        return new CursorResponse<>(
            commentResponses,
            nextCursor,
            hasNext
        );
    }
}
