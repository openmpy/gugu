package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<Member, Long> {

    boolean existsByPhone_Value(final String value);

    boolean existsByNickname_Value(final String value);
}
