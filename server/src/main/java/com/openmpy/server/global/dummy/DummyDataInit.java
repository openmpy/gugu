package com.openmpy.server.global.dummy;

import static com.openmpy.server.member.domain.constants.MemberGender.FEMALE;
import static com.openmpy.server.member.domain.constants.MemberGender.MALE;

import com.openmpy.server.member.domain.entity.Member;
import com.openmpy.server.member.repository.MemberRepository;
import java.util.ArrayList;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class DummyDataInit {

    @Profile("local")
    @Bean
    CommandLineRunner init(
        final MemberRepository memberRepository
    ) {
        return _ -> {
            final List<Member> members = new ArrayList<>();

            for (int i = 0; i < 100; i++) {
                final String phone = String.format("01000000%03d", i);

                final Member member = Member.create(
                    phone,
                    "1234",
                    i % 2 == 0 ? MALE : FEMALE
                );

                member.writeComment("코멘트" + i);
                members.add(member);
            }

            memberRepository.saveAll(members);
            log.info("{}개의 회원 데이터가 저장되었습니다", memberRepository.count());
        };
    }
}
