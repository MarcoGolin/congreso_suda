package py.com.flextech.model.sistema;


import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;

import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import com.google.gson.annotations.JsonAdapter;

import lombok.Getter;
import lombok.Setter;
import py.com.flextech.utils.adapter.LocalDateTimeAdapter;

@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public class Auditable<U> {

    //updatable flag helps to avoid the override of
    //column's value during the update operation
    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private U createdBy;

    //updatable flag helps to avoid the override of
    //column's value during the update operation
    @CreatedDate
    @Column(name = "created_date", updatable = false)
    @JsonAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime  createdDate;

    @LastModifiedBy
    @Column(name = "last_modified_by")
    private U lastModifiedBy;

    @LastModifiedDate
    @Column(name = "last_modified_date")
	@JsonAdapter(LocalDateTimeAdapter.class)
    private LocalDateTime  lastModifiedDate;
    
    
    
//    @PrePersist
//    public void onCreate() {
//        this.createdDate = LocalDateTime.now(ZoneId.of("UTC"));
//        this.lastModifiedDate = LocalDateTime.now(ZoneId.of("UTC"));
//    }
//
//    @PreUpdate
//    public void onUpdate() {
//        this.lastModifiedDate = LocalDateTime.now(ZoneId.of("UTC"));
//    }
}
