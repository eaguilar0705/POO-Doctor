<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.persistence.*" %>
<%@ page import="org.openxava.jpa.XPersistence" %>
<%@ page import="org.example.ProyectoPOO.model.bodega.Paquete" %>
<%@ page import="org.example.ProyectoPOO.model.bodega.Movimiento" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Portal de Servicios - ProyectoPOO</title>
    <link rel="stylesheet" href="rastreo.css">
</head>
<body>

<div class="header">
    <h1>Portal de Servicios</h1>
</div>

<div class="container">

    <!-- PESTAÑAS -->
    <div class="tabs">
        <button class="tab-link active" onclick="openTab(event, 'Rastreo')">Rastreo de Paquetes</button>
        <button class="tab-link" onclick="openTab(event, 'Cotizar')">Cotizar Envío</button>
    </div>

    <!-- TAB RASTREO -->
    <div id="Rastreo" class="tab-content active">
        <div class="search-box">
            <form method="get" action="rastreo.jsp" class="search-form">
                <label for="tracking">Ingresa tu código de rastreo</label>
                <input type="text"
                       id="tracking"
                       name="tracking"
                       placeholder="Ej: USA0001, USA0002..."
                       required
                       value="<%= request.getParameter("tracking") != null ? request.getParameter("tracking") : "" %>">
                <button type="submit">
                    <span>🔍</span>
                    <span>Rastrear</span>
                </button>
            </form>
        </div>

        <%
            String trackingCode = request.getParameter("tracking");

            if (trackingCode != null && !trackingCode.trim().isEmpty()) {
                EntityManager em = XPersistence.getManager();

                try {
                    String jpql = "SELECT p FROM Paquete p WHERE p.trackingProveedor = :code";
                    TypedQuery<Paquete> query = em.createQuery(jpql, Paquete.class);
                    query.setParameter("code", trackingCode.trim());

                    Paquete paquete = query.getSingleResult();

                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        %>

        <div class="result-card">
            <div class="result-header">
                <h3>Paquete #<%= paquete.getId() %></h3>
                <span class="status-badge"><%= paquete.getEstadoActual() %></span>
            </div>

            <p><strong>Descripción:</strong> <%= paquete.getDescripcion() %></p>
            <p><strong>Código de tracking:</strong> <%= paquete.getTrackingProveedor() %></p>

            <hr>

            <h4>Ubicación actual</h4>
            <p>
                <%= (paquete.getUbicacionActual() != null)
                        ? paquete.getUbicacionActual().getNombre()
                        : "En tránsito internacional / Sin sucursal asignada" %>
            </p>

            <%
                List<Movimiento> historial = paquete.getHistorial();
                if (historial != null && !historial.isEmpty()) {
            %>
            <h4>Historial de movimientos</h4>
            <div class="timeline">
                <%
                    for (Movimiento mov : historial) {
                %>
                <div class="timeline-item">
                    <strong><%= mov.getEstado() %></strong><br>
                    <small>
                        <%= (mov.getTimestamp() != null)
                                ? mov.getTimestamp().format(formatter)
                                : "" %>
                    </small>
                    <p><%= mov.getDescripcion() != null ? mov.getDescripcion() : "" %></p>
                </div>
                <%
                    }
                %>
            </div>
            <%
            } else {
            %>
            <p class="info-text">No hay movimientos registrados aún.</p>
            <%
                }
            %>
        </div>

        <%
        } catch (NoResultException e) {
        %>
        <div class="result-card">
            <h3 class="error-msg">No encontrado</h3>
            <p>No pudimos encontrar un paquete con el código <strong><%= trackingCode %></strong>.</p>
            <p class="info-text">Verifica que el código esté correcto y que el envío esté registrado en el sistema.</p>
        </div>
        <%
        } catch (Exception e) {
        %>
        <p class="error-msg">
            Error del sistema: <%= e.getMessage() %>
        </p>
        <%
                e.printStackTrace();
            }
        } else if (request.getParameter("tracking") != null) {
        %>
        <p class="info-text">
            Ingresa un código de rastreo en el panel superior para ver el estado de tu envío.
        </p>
        <%
            }
        %>
    </div>

    <!-- TAB COTIZAR -->
    <div id="Cotizar" class="tab-content">
        <div class="search-box">
            <form id="cotizar-form" class="search-form">
                <label for="peso">Peso del producto (libras)</label>
                <input type="number" id="peso" name="peso" placeholder="Ej: 10" required step="0.01">

                <label for="metodo-envio">Método de Envío</label>
                <select id="metodo-envio" name="metodo-envio">
                    <option value="aereo">Aéreo ($7.50/libra)</option>
                    <option value="maritimo">Marítimo ($2.50/libra)</option>
                </select>

                <button type="submit">
                    <span>💲</span>
                    <span>Calcular</span>
                </button>
            </form>
        </div>

        <div id="resultado-cotizacion" class="result-card" style="display: none;">
            <h3>Resultado de la Cotización</h3>
            <p id="costo-envio"></p>
            <p id="detalle-envio"></p>
        </div>
    </div>

    <div class="footer">
        © <%= java.time.Year.now() %> ProyectoPOO
    </div>

</div>

<script>
    // Cambiar entre pestañas
    function openTab(evt, tabName) {
        var i;
        var tabcontent = document.getElementsByClassName("tab-content");
        var tablinks = document.getElementsByClassName("tab-link");

        // Ocultar todos los contenidos
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].classList.remove("active");
        }

        // Quitar "active" de todos los botones
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].classList.remove("active");
        }

        // Activar contenido y botón actual
        document.getElementById(tabName).classList.add("active");
        evt.currentTarget.classList.add("active");
    }

    // Asegurar que alguna pestaña esté activa al cargar
    document.addEventListener('DOMContentLoaded', function() {
        var activeContent = document.querySelector('.tab-content.active');
        var activeButton = document.querySelector('.tab-link.active');

        if (!activeContent && document.getElementById('Rastreo')) {
            document.getElementById('Rastreo').classList.add('active');
        }
        if (!activeButton) {
            var firstButton = document.querySelector('.tab-link');
            if (firstButton) firstButton.classList.add('active');
        }
    });

    // Lógica de cotización
    document.getElementById('cotizar-form').addEventListener('submit', function(e) {
        e.preventDefault();

        var peso = parseFloat(document.getElementById('peso').value);
        var metodo = document.getElementById('metodo-envio').value;
        var costo;
        var detalle;

        if (isNaN(peso) || peso <= 0) {
            alert("Por favor, ingrese un peso válido.");
            return;
        }

        if (metodo === 'aereo') {
            costo = peso * 7.50;
            detalle = "Envío aéreo: tiempo estimado de 24 a 72 horas. Ideal cuando quieres tu paquete lo más rápido posible.";
        } else {
            costo = peso * 2.50;
            detalle = "Envío marítimo: tiempo estimado de 12 a 15 días. Ideal para productos pesados o si eres un emprendedor con alta demanda de paquetes.";
        }

        document.getElementById('costo-envio').innerText =
            'El costo estimado del envío es: $' + costo.toFixed(2);
        document.getElementById('detalle-envio').innerText = detalle;
        document.getElementById('resultado-cotizacion').style.display = 'block';
    });
</script>

</body>
</html>
