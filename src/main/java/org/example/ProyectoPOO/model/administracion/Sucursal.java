package org.example.ProyectoPOO.model.administracion;

import lombok.Getter;
import lombok.Setter;
import org.example.ProyectoPOO.model.BaseEntity;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
@Getter @Setter
public class Sucursal extends BaseEntity {

    @Column(length = 80)
    private String nombre;

    @Column(length = 150)
    private String direccion;

    @Column(length = 50)
    private String horario;
}
