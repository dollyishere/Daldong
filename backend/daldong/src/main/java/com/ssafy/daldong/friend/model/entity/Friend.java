package com.ssafy.daldong.friend.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Table(name = "friend")
@IdClass(FriendId.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Friend {

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "friend_id", nullable = false)
    private User friend;

    @Column(name = "is_sting", nullable = false)
    private boolean isSting;
}
