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
        <button class="tab-link active" data-target="Rastreo">Rastreo de Paquetes</button>
        <button class="tab-link" data-target="Cotizar">Cotizar Envío</button>
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
                <input type="number" id="peso" name="peso" placeholder="Ej: 10" required step="0.01" min="0.01">

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
    document.addEventListener('DOMContentLoaded', function () {
        // Manejo de pestañas (delegación simple)
        document.querySelectorAll('.tab-link').forEach(function(btn) {
            btn.addEventListener('click', function (evt) {
                var target = btn.getAttribute('data-target');
                if (!target) return;

                // ocultar todos los contenidos y quitar active de botones
                document.querySelectorAll('.tab-content').forEach(function(tc){ tc.classList.remove('active'); });
                document.querySelectorAll('.tab-link').forEach(function(b){ b.classList.remove('active'); });

                var content = document.getElementById(target);
                if (content) content.classList.add('active');
                btn.classList.add('active');
            });
        });

        // Listener seguro para el formulario de cotización
        var cotizarForm = document.getElementById('cotizar-form');
        if (cotizarForm) {
            cotizarForm.addEventListener('submit', function (e) {
                e.preventDefault();

                var pesoInput = document.getElementById('peso');
                var metodoSelect = document.getElementById('metodo-envio');
                var resultadoCard = document.getElementById('resultado-cotizacion');
                var costoElem = document.getElementById('costo-envio');
                var detalleElem = document.getElementById('detalle-envio');

                var peso = parseFloat(pesoInput.value);
                var metodo = metodoSelect.value;
                var costo = 0;
                var detalle = '';

                if (isNaN(peso) || peso <= 0) {
                    alert("Por favor, ingrese un peso válido mayor que 0.");
                    return;
                }

                if (metodo === 'aereo') {
                    costo = peso * 7.50;
                    detalle = "Envío aéreo: tiempo estimado de 24 a 72 horas. Ideal cuando quieres tu paquete lo más rápido posible.";
                } else {
                    costo = peso * 2.50;
                    detalle = "Envío marítimo: tiempo estimado de 12 a 15 días. Ideal para productos pesados o envíos en volumen.";
                }

                // Mostrar resultados
                costoElem.innerText = 'El costo estimado del envío es: $' + costo.toFixed(2);
                detalleElem.innerText = detalle;
                if (resultadoCard) resultadoCard.style.display = 'block';

                // Opcional: cambiar a la pestaña Cotizar si no está activa
                var cotizarTabBtn = document.querySelector('.tab-link[data-target="Cotizar"]');
                if (cotizarTabBtn && !document.getElementById('Cotizar').classList.contains('active')) {
                    cotizarTabBtn.click();
                }
            });
        }
    });
</script>

</body>
</html>
