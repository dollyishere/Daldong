package com.ssafy.daldong.friend.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Table(name = "friendRequest")
@IdClass(FriendRequestId.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FriendRequest {

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender;

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver;
}
