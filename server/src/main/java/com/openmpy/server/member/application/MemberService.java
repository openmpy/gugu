package com.openmpy.server.member.application;

import com.openmpy.server.global.dto.CursorResponse;
import com.openmpy.server.global.exception.CustomException;
import com.openmpy.server.member.domain.constants.MemberGender;
import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.dto.request.MemberUpdateLocationRequest;
import com.openmpy.server.member.dto.request.MemberWriteCommentRequest;
import com.openmpy.server.member.dto.response.MemberGetCommentResponse;
import com.openmpy.server.member.repository.MemberRepository;
import com.openmpy.server.member.repository.projection.MemberWithDistanceProjection;
import java.time.LocalDate;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
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
        final String gender,
        final Long cursorId,
        final Integer size
    ) {
        final String upperGender = gender.toUpperCase();

        if (!upperGender.equals("ALL") &&
            !upperGender.equals("MALE") &&
            !upperGender.equals("FEMALE")
        ) {
            throw new CustomException("성별이 올바르지 않습니다.");
        }

        final Member member = memberRepository.getReferenceById(memberId);

        // 위치 O
        if (member.getLocation() != null) {
            final List<MemberWithDistanceProjection> members;

            if (upperGender.equals("ALL")) {
                members = memberRepository.findAllByIdWithDistance(
                    memberId,
                    member.getLocation(),
                    cursorId,
                    PageRequest.of(0, size + 1)
                );
            } else {
                members = memberRepository.findAllByIdAndGenderWithDistance(
                    memberId,
                    member.getLocation(),
                    upperGender,
                    cursorId,
                    PageRequest.of(0, size + 1)
                );
            }

            final boolean hasNext = members.size() > size;
            final List<MemberWithDistanceProjection> pageMembers =
                hasNext ? members.subList(0, size) : members;

            final List<MemberGetCommentResponse> commentResponses = pageMembers.stream()
                .map(it -> new MemberGetCommentResponse(
                    it.getId(),
                    it.getNickname(),
                    it.getGender(),
                    LocalDate.now().getYear() - it.getBirthYear(),
                    100,
                    it.getDistance(),
                    it.getComment(),
                    it.getUpdatedAt()
                ))
                .toList();

            return new CursorResponse<>(
                commentResponses,
                hasNext ? pageMembers.getLast().getId() : null,
                hasNext
            );
        }

        // 위치 X
        final List<Member> members;

        if (upperGender.equals("ALL")) {
            members = memberRepository.findAllByIdWithoutDistance(
                memberId,
                cursorId,
                PageRequest.of(0, size + 1)
            );
        } else {
            members = memberRepository.findAllByIdAndGenderWithoutDistance(
                memberId,
                MemberGender.valueOf(upperGender),
                cursorId,
                PageRequest.of(0, size + 1)
            );
        }

        final boolean hasNext = members.size() > size;
        final List<Member> pageMembers = hasNext ? members.subList(0, size) : members;

        final List<MemberGetCommentResponse> commentResponses = pageMembers.stream()
            .map(it -> new MemberGetCommentResponse(
                it.getId(),
                it.getNickname(),
                it.getGender(),
                LocalDate.now().getYear() - it.getBirthYear(),
                100,
                null,
                it.getComment(),
                it.getUpdatedAt()
            ))
            .toList();

        return new CursorResponse<>(
            commentResponses,
            hasNext ? pageMembers.getLast().getId() : null,
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
