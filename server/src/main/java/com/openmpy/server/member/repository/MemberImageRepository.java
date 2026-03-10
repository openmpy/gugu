package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.entity.MemberImage;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberImageRepository extends JpaRepository<MemberImage, Long> {

    Optional<MemberImage> findByIdAndMember(final Long id, final Member member);
}
