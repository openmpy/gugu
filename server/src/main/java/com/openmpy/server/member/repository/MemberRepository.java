package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.vo.MemberPhone;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByPhone(final MemberPhone phone);

    boolean existsByPhone_Value(final String value);

    boolean existsByNickname_Value(final String value);
}
