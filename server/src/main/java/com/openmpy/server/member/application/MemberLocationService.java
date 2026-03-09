package com.openmpy.server.member.application;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.entity.MemberLocation;
import com.openmpy.server.member.dto.request.MemberUpsertLocationRequest;
import com.openmpy.server.member.repository.MemberLocationRepository;
import com.openmpy.server.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class MemberLocationService {

    private final MemberRepository memberRepository;
    private final MemberLocationRepository memberLocationRepository;

    @Transactional
    public void upsertLocation(final Long memberId, final MemberUpsertLocationRequest request) {
        final Member member = memberRepository.getReferenceById(memberId);

        final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(), 4326);
        final Point point = geometryFactory.createPoint(
            new Coordinate(request.longitude(), request.latitude())
        );

        memberLocationRepository.findByMember(member)
            .ifPresentOrElse(it -> it.updateLocation(point),
                () -> {
                    final MemberLocation memberLocation = MemberLocation.create(member, point);
                    memberLocationRepository.save(memberLocation);
                }
            );
    }
}
