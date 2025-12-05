package org.example.ProyectoPOO.model.bodega;

import lombok.Getter;
import lombok.Setter;
import org.example.ProyectoPOO.model.BaseEntity;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
@Getter @Setter
public class Categoria extends BaseEntity {

    @Column(length = 60)
    private String nombre;

    @Column(length = 150)
    private String descripcion;
}
