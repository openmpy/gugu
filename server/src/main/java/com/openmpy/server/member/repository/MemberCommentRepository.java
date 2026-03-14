package com.openmpy.server.member.repository;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.domain.entity.MemberComment;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemberCommentRepository extends JpaRepository<MemberComment, Long> {

    Optional<MemberComment> findFirstByMemberOrderByUpdatedAtDesc(final Member member);
}
