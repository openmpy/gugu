package com.openmpy.server.member.repository.projection;

import com.openmpy.server.member.domain.constants.MemberGender;
import java.time.LocalDateTime;

public interface MemberWithDistanceProjection {

    Long getId();

    String getNickname();

    MemberGender getGender();

    Integer getBirthYear();

    Double getDistance();

    String getComment();

    LocalDateTime getUpdatedAt();
}
