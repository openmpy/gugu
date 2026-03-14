package com.openmpy.server.member.application;

import com.openmpy.server.global.dto.CursorResponse;
import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberUpdateLocationRequest;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import com.openmpy.server.member.dto.response.MemberGetCommentResponse;
import com.openmpy.server.member.repository.MemberRepository;
import com.openmpy.server.member.repository.projection.MemberGetCommentProjection;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
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
        final String gender,
        final Long cursorId,
        final Integer size
    ) {
        final Member member = memberRepository.getReferenceById(memberId);

        final List<MemberGetCommentProjection> members = memberRepository.findMembersWithDistance(
            memberId,
            gender.toUpperCase(),
            member.getLocation(),
            cursorId,
            size + 1
        );
        final List<MemberGetCommentResponse> commentResponses = members.stream()
            .map(it -> new MemberGetCommentResponse(
                it.memberId(),
                it.nickname(),
                MemberGender.valueOf(it.gender()),
                LocalDate.now().getYear() - it.birthYear(),
                100,
                it.distance(),
                it.comment(),
                it.updatedAt()
            ))
            .toList();

        final boolean hasNext = members.size() > size;
        final Long nextCursorId = hasNext ? members.getLast().memberId() : null;

        return new CursorResponse<>(
            commentResponses,
            nextCursorId,
            hasNext
        );
    }

    @Transactional
    public void bumpComment(final Long memberId) {
        final Member member = memberRepository.getReferenceById(memberId);

        member.bumpComment();
    }

    @Transactional
    public void updateLocation(final Long memberId, final MemberUpdateLocationRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        if (request.latitude() == null || request.longitude() == null) {
            member.updateLocation(null);
            return;
        }

        final GeometryFactory geometryFactory = new GeometryFactory();
        final Point point = geometryFactory.createPoint(
            new Coordinate(request.longitude(), request.latitude())
        );

        member.updateLocation(point);
    }
}
